#include <stdio.h>
#include <stdlib.h>
#include <png.h>
#include <math.h>
#include <pthread.h>
#include <time.h>

#define GAUSSIAN_RADIUS 2
#define MAX_THREADS 4
#define CLOCK_MONOTONIC 1

typedef struct {
    png_bytep *row_pointers;
    png_bytep *copy;
    int start_y;
    int end_y;
    int width;
    int channels;
} ThreadData;

double gaussian_kernel[5][5] = {
    {1.0, 4.0, 6.0, 4.0, 1.0},
    {4.0, 16.0, 24.0, 16.0, 4.0},
    {6.0, 24.0, 36.0, 24.0, 6.0},
    {4.0, 16.0, 24.0, 16.0, 4.0},
    {1.0, 4.0, 6.0, 4.0, 1.0}
};

void *apply_gaussian_filter_thread(void *arg) {
    ThreadData *data = (ThreadData *)arg;

    for (int y = data->start_y; y < data->end_y; y++) {
        for (int x = GAUSSIAN_RADIUS * data->channels; x < (data->width - GAUSSIAN_RADIUS) * data->channels; x += data->channels) {
            for (int c = 0; c < data->channels; c++) {
                double sum = 0;
                for (int ky = -GAUSSIAN_RADIUS; ky <= GAUSSIAN_RADIUS; ky++) {
                    for (int kx = -GAUSSIAN_RADIUS; kx <= GAUSSIAN_RADIUS; kx++) {
                        sum += data->copy[y + ky][x + kx * data->channels + c] * gaussian_kernel[ky + GAUSSIAN_RADIUS][kx + GAUSSIAN_RADIUS];
                    }
                }
                data->row_pointers[y][x + c] = (png_byte)(sum / 256);
            }
        }
    }

    return NULL;
}

void apply_gaussian_filter(png_bytep *row_pointers, int width, int height, int channels, int num_threads) {
    // Create a copy of the image data
    png_bytep *copy = malloc(height * sizeof(png_bytep));
    for (int y = 0; y < height; y++) {
        copy[y] = malloc(width * channels * sizeof(png_byte));
        for (int x = 0; x < width * channels; x++) {
            copy[y][x] = row_pointers[y][x];
        }
    }

    pthread_t threads[num_threads];
    ThreadData thread_data[num_threads];

    for (int i = 0; i < num_threads; i++) {
        thread_data[i].row_pointers = row_pointers;
        thread_data[i].copy = copy;
        thread_data[i].start_y = GAUSSIAN_RADIUS + i * (height - 2 * GAUSSIAN_RADIUS) / num_threads;
        thread_data[i].end_y = GAUSSIAN_RADIUS + (i + 1) * (height - 2 * GAUSSIAN_RADIUS) / num_threads;
        thread_data[i].width = width;
        thread_data[i].channels = channels;

        pthread_create(&threads[i], NULL, apply_gaussian_filter_thread, &thread_data[i]);
    }

    for (int i = 0; i < num_threads; i++) {
        pthread_join(threads[i], NULL);
    }

    for (int y = 0; y < height; y++) {
        free(copy[y]);
    }
    free(copy);
}

png_bytep *read_png_file(const char *filename, int *width, int *height, int *channels) {
    FILE *fp = fopen(filename, "rb");
    if (!fp) {
        perror("File opening failed");
        return NULL;
    }

    png_structp png = png_create_read_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
    if (!png) abort();

    png_infop info = png_create_info_struct(png);
    if (!info) abort();

    if (setjmp(png_jmpbuf(png))) abort();

    png_init_io(png, fp);
    png_read_info(png, info);

    *width = png_get_image_width(png, info);
    *height = png_get_image_height(png, info);
    png_byte bit_depth = png_get_bit_depth(png, info);
    png_byte color_type = png_get_color_type(png, info);

    if (bit_depth == 16)
        png_set_strip_16(png);

    if (color_type == PNG_COLOR_TYPE_PALETTE)
        png_set_palette_to_rgb(png);

    if (color_type == PNG_COLOR_TYPE_GRAY && bit_depth < 8)
        png_set_expand_gray_1_2_4_to_8(png);

    if (png_get_valid(png, info, PNG_INFO_tRNS))
        png_set_tRNS_to_alpha(png);

    if (color_type == PNG_COLOR_TYPE_RGB ||
        color_type == PNG_COLOR_TYPE_GRAY ||
        color_type == PNG_COLOR_TYPE_PALETTE)
        png_set_filler(png, 0xFF, PNG_FILLER_AFTER);

    if (color_type == PNG_COLOR_TYPE_GRAY ||
        color_type == PNG_COLOR_TYPE_GRAY_ALPHA)
        png_set_gray_to_rgb(png);

    png_read_update_info(png, info);

    png_bytep *row_pointers = malloc(sizeof(png_bytep) * (*height));
    for (int y = 0; y < *height; y++) {
        row_pointers[y] = malloc(png_get_rowbytes(png, info));
    }

    png_read_image(png, row_pointers);
    fclose(fp);

    *channels = png_get_channels(png, info);
    png_destroy_read_struct(&png, &info, NULL);

    return row_pointers;
}

void write_png_file(const char *filename, png_bytep *row_pointers, int width, int height) {
    FILE *fp = fopen(filename, "wb");
    if (!fp) {
        perror("File opening failed");
        return;
    }

    png_structp png = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
    if (!png) abort();

    png_infop info = png_create_info_struct(png);
    if (!info) abort();

    if (setjmp(png_jmpbuf(png))) abort();

    png_init_io(png, fp);
    png_set_IHDR(
        png,
        info,
        width, height,
        8,
        PNG_COLOR_TYPE_RGBA,
        PNG_INTERLACE_NONE,
        PNG_COMPRESSION_TYPE_DEFAULT,
        PNG_FILTER_TYPE_DEFAULT
    );
    png_write_info(png, info);

    png_write_image(png, row_pointers);
    png_write_end(png, NULL);

    for (int y = 0; y < height; y++) {
        free(row_pointers[y]);
    }
    free(row_pointers);

    fclose(fp);
    png_destroy_write_struct(&png, &info);
}

void measure_execution_time(png_bytep *row_pointers, int width, int height, int channels) {
    struct timespec start, end;

    for (int num_threads = 1; num_threads <= MAX_THREADS; num_threads++) {
        clock_gettime(CLOCK_MONOTONIC, &start);
        apply_gaussian_filter(row_pointers, width, height, channels, num_threads);
        clock_gettime(CLOCK_MONOTONIC, &end);

        double elapsed_time = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
        printf("Execution time with %d thread(s): %f seconds\n", num_threads, elapsed_time);
    }
}

int main() {
    int width, height, channels;
    png_bytep *row_pointers = read_png_file("pictures/input.png", &width, &height, &channels);
        if (!row_pointers) {
         return EXIT_FAILURE;
             }

    //measure_execution_time(row_pointers, width, height, channels);
    struct timespec start, end;
  
    for(int number_of_threads = 1; number_of_threads<=MAX_THREADS; number_of_threads++)
    {
        clock_gettime(CLOCK_MONOTONIC, &start);
        png_bytep *row_pointers = read_png_file("pictures/input.png", &width, &height, &channels);
        char* base_name = "gauss_pictures/output";
        char output_name[100];
        apply_gaussian_filter(row_pointers, width, height, channels, number_of_threads);
        snprintf(output_name, sizeof(output_name), "%s%d.png", base_name, number_of_threads);
        write_png_file(output_name, row_pointers, width, height);
        clock_gettime(CLOCK_MONOTONIC, &end);
        double elapsed_time = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
        printf("Execution time with %d thread(s): %f seconds\n", number_of_threads, elapsed_time);
    }
    
   
    printf("Done\n");

    return EXIT_SUCCESS;
}

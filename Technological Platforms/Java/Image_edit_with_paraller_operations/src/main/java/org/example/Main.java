package org.example;
import org.apache.commons.lang3.tuple.Pair;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.nio.file.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.stream.Stream;


public class Main {
    private static Path destination;
    private static ImageTransformationMethod transformationMethod;

    public enum ImageTransformationMethod {
        FLIP_UPSIDE_DOWN {
            @Override
            public BufferedImage transform(BufferedImage original) {
                return flipImageUpsideDown(original);
            }
        },
        CHANGE_BLUE_AND_GREEN {
            @Override
            public BufferedImage transform(BufferedImage original) {
                return changeBlueAndGreen(original);
            }
        },
        MIRROR {
            @Override
            public BufferedImage transform(BufferedImage original) {
                return mirrorImage(original);
            }
        };

        public abstract BufferedImage transform(BufferedImage original);
    }
    public static void main(String[] args) {

        if (args.length != 2) {
            throw new IllegalArgumentException("Usage: <source directory> <destination directory>");
        }
        Path source = Path.of(args[0]);
        destination = Path.of(args[1]);
        int numberOfThreads = Runtime.getRuntime().availableProcessors();
        SetUp();
        for (int i = 1; i <= numberOfThreads; i++) {

            ExecutorService executor = Executors.newFixedThreadPool(i);
            float startTime = System.nanoTime();



            try {
                createDestinationDirectory();
            } catch (IOException e) {
                throw new RuntimeException(STR."Error creating directory: \{destination}", e);
            }

            List<Path> files = new ArrayList<>();
            try (Stream<Path> stream = Files.list(source)) {
                files = stream.toList();
            } catch (IOException e) {
                e.printStackTrace();
            }

            Path finalDestination = destination;
            files.parallelStream()
                    .forEach(path -> executor.submit(() ->
                    {

                        BufferedImage image;
                        try {
                            image = ImageIO.read(path.toFile());
                        } catch (IOException e) {
                            throw new RuntimeException(e);
                        }
                        String name = path.getFileName().toString();
                        Pair<String, BufferedImage> pair = Pair.of(name, image);
                        Pair<String, BufferedImage> newPair = transformImage(pair, transformationMethod);
                        saveImage(newPair, finalDestination);

                    }));
            executor.shutdown();
            while (!executor.isTerminated()) {}
            float endTime = System.nanoTime();
            float timeElapsed = endTime - startTime;
            System.out.println(STR."Execution time in milliseconds for \{i} threads: \{timeElapsed / 1000000}");
        }

    }

    private static void SetUp() {
        Scanner scanner = new Scanner(System.in);
        System.out.println("Enter transformation method: ");
        String method = scanner.nextLine();
        transformationMethod = ImageTransformationMethod.valueOf(method.toUpperCase());
        destination = destination.resolve(transformationMethod.name().toLowerCase());

    }

    private static void createDestinationDirectory() throws IOException {
        Files.createDirectories(destination);
    }

    public static Pair<String, BufferedImage> transformImage(Pair<String, BufferedImage> original, ImageTransformationMethod transformationMethod) {
        String name = original.getLeft();
        BufferedImage image = original.getRight();
        BufferedImage newImage = transformationMethod.transform(image);
        return Pair.of(name, newImage);
    }

    public static BufferedImage changeBlueAndGreen(BufferedImage original) {
        int width = original.getWidth();
        int height = original.getHeight();
        BufferedImage newImage = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);

        for (int x = 0; x < width; x++) {
            for (int y = 0; y < height; y++) {
                int rgb = original.getRGB(x, y);
                Color color = new Color(rgb);
                int red = color.getRed();
                int blue = color.getBlue();
                int green = color.getGreen();
                Color outColor = new Color(red, blue, green);
                newImage.setRGB(x, y, outColor.getRGB());
            }
        }

        return newImage;
    }

    public static void saveImage(Pair<String, BufferedImage> pair, Path destination) {

        String name = pair.getLeft();
        BufferedImage image = pair.getRight();

        Path imagePath = destination.resolve(name);
        try {
            ImageIO.write(image, "jpg", imagePath.toFile());
        } catch (IOException e) {
            throw new RuntimeException(STR."Error saving image: \{imagePath}", e);
        }
    }

    public static BufferedImage flipImageUpsideDown(BufferedImage original) {
        int width = original.getWidth();
        int height = original.getHeight();
        BufferedImage newImage = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);

        for (int x = 0; x < width; x++) {
            for (int y = 0; y < height; y++) {
                int rgb = original.getRGB(x, y);
                newImage.setRGB(x, height - y - 1, rgb);
            }
        }
        return newImage;
    }

    public static BufferedImage mirrorImage(BufferedImage original) {
        int width = original.getWidth();
        int height = original.getHeight();
        BufferedImage newImage = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);

        for (int x = 0; x < width; x++) {
            for (int y = 0; y < height; y++) {
                int rgb = original.getRGB(x, y);
                newImage.setRGB(width - x - 1, y, rgb);
            }
        }
        return newImage;
    }


}
clear all
close all
format compact

n_max = 200;
a = 20
r_max = a/2
  
       
        
[circles, index_number] = generate_circles(a, r_max, n_max);
plot_circles(a, circles, index_number); 
print -dpng zadanie1.png 
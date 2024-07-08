function [circles, index_number] = generate_circles(a, r_max, n_max)
    index_number = 193415; % Your index number
    L1 = 5;

    circles = [];
    for i = 1:n_max
        R = rand() * r_max;
        X = rand() * a;
        Y = rand() * a;
        
        overlaps = true;
        while overlaps
            overlaps = false;
            
            % Check if the new circle is within the square region
            if X - R >= 0 && X + R <= a && Y - R >= 0 && Y + R <= a
                % Check for overlaps with existing circles
                for j = 1:i
                    if i ~= j
                    distance = sqrt((X - circles(2, j))^2 + (Y - circles(3, j))^2);
                    if distance < (R + circles(1, j))
                        overlaps = true;
                        break;
                    end
                    end
                end
            else
                overlaps = true;
            end
            
            % Generate new positions if there's an overlap
            if overlaps
                X = rand() * a;
                Y = rand() * a;
                R = rand() * r_max;
            end
        end
        
       new_circle = [R; X; Y];
       circles = [circles, new_circle];
    end
end

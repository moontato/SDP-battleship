function [row, col, dir, hit_grid_out] = AI(user_positions_grid, hit_grid, last_hit_location, direction)
    % last_hit_last_hit_location: a vector containing last successful hit
    % 0 in last_hit_location means previous shot was off target

    [hSize, vSize] = size(hit_grid);

    % if no hit was made during previous turn, go random
    if(last_hit_location(1) == 0)

        r = randi(10);
        c = randi(10);
        dir = randi(4);

        % find a random position that hasn't been hit yet
        while(hit_grid(r, c) > 0)
            r = randi(10);
            c = randi(10);
        end

        % return values
        row = r;
        col = c;

    % if a hit was made during previous turn, shoot around previous location
    else

        r = -1;
        c = -1;

        %{
            direction 0: no direction (N/A)
            direction 1: right
            direction 2: up
            direction 3: left
            direction 4: down
        %}

        % check if last shot was at edge
        atEdge = checkShot(hit_grid, last_hit_location(1), last_hit_location(2), direction);

        % if last shot was at edge, move the placement of next shot
        if(atEdge)
            [row, col, dir] = moveShot(hit_grid, last_hit_location(1), last_hit_location(2), direction);
        % if last shot was not at edge, fire the next shot as normal
        % (pointing in direction 1, 2, 3, or 4)
        else
            % right
            if(direction == 1)
                r = last_hit_location(1);
                c = last_hit_location(2) + 1;
            % up
            elseif(direction == 2)
                r = last_hit_location(1) - 1;
                c = last_hit_location(2);
            % left
            elseif(direction == 3)
                r = last_hit_location(1);
                c = last_hit_location(2) - 1;
            % down
            else
                r = last_hit_location(1) + 1;
                c = last_hit_location(2);
            end


            % check if index (r, c) is already hit or missed
            if(hit_grid(r, c) > 0)
                new_r = r;
                new_c = c;
                new_direction = 0;

                % while position is not empty
                while(hit_grid(new_r, new_c) > 0)
                    if(new_direction > 4)
                        % keep generating a new position if all directions
                        % have been checked (4 directions)
                        new_r = randi(10);
                        new_c = randi(10);
                        direction = randi(4);
                    else
                        % check all directions
                        new_direction = new_direction + 1;
                        [new_r, new_c] = moveShot(hit_grid, r, c, new_direction);
                    end
                end
                r = new_r;
                c = new_c;

            end
            row = r;
            col = c;
            dir = direction;
        end
    end
    hit_grid_out = hit_grid;
end

function atEdge = checkShot(hit_grid, r, c, direction)
    [hSize, vSize] = size(hit_grid);

    if((r == 1 || r == vSize) || (c == 1 || c == hSize))
        atEdge = true;
    else
        atEdge = false;
    end
end

function [new_r, new_c, new_dir] = moveShot(hit_grid, r, c, direction)
    [hSize, vSize] = size(hit_grid);

    % check if initial direction reaches out of board

    % initial search direction was right, so go left
    if(direction == 1)
        % if direction leads to end of board, loop back
        if(c + 1 > hSize)
            while(hit_grid(r, c) > 0 && c > 1)
                c = c - 1;
            end
            direction = 3;
        
        % if direction leads to valid position, go through with it
        else
            c = c + 1;
        end

    % initial search is up, so go down
    elseif(direction == 2)
        if(r - 1 < 1)
            while(hit_grid(r, c) > 0 && r < vSize)
                r = r + 1;
            end
            direction = 4;

        else
            r = r - 1;
        end


    % initial direction was left, so go right
    elseif(direction == 3)
        if(c - 1 < 1)
            while(hit_grid(r, c) > 0 && c < hSize)
                c = c + 1;
            end
            direction = 1;

        else
            c = c - 1;
        end

    % initial direction was down, so go up
    elseif(direction == 4)
        if(r + 1 > vSize)
            while(hit_grid(r, c) > 0 && r > 1)
                r = r - 1;
            end
            direction = 2;

        else
            r = r + 1;
        end
    end

    new_r = r;
    new_c = c;
    new_dir = direction;
end

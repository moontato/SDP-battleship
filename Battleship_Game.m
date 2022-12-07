warning('off', 'all');
clear 
clc
close all
play_again_final = true;

while play_again_final == true
    
% creating scenes
start_scene = simpleGameEngine('4gridsprites.png', 83, 84, 4, [245, 245, 245]);
board = [1:5; 6:10; 11:15; 16:20; 21:25; 26:30; 31:35; 36:40;];


%Setting up variables from the 2gridsprites.png

water_sprite = 27;
left_ship_sprite = 28;
horiz_ship_sprite = 29;
right_ship_sprite = 30;
top_ship_sprite = 31;
vert_ship_sprite = 32;
bot_ship_sprite = 33;
hit_sprite = 34;
miss_sprite = 35;
metal_sheet = 36;
metal_brick = 37;
black_blank = 38;
blank_sprite = 39;


%Title screen display
board_display1 =  metal_brick * ones(10,10);
board_display1([1,10], :) = metal_sheet;


%Word display to have overlapping sprites for the start screen
words = blank_sprite * ones(10,10);
words(3, :) = [2, 1, 20, 20, 12, 5, 19, 8, 9, 16];

words(5, 4:7) = [16, 12, 1, 25];

words(7, 4:7) = [17, 21, 9, 20];

% Ship board when user is placing ships

ships = water_sprite * ones(10,16);
ships(:, 11:16) = blank_sprite;

ships(1, 12:16) = top_ship_sprite;
ships(2:4, 12) = vert_ship_sprite;
ships(2:3, 13) = vert_ship_sprite;
ships(2,14:15) = vert_ship_sprite;
ships(5, 12) = bot_ship_sprite;
ships(4, 13) = bot_ship_sprite;
ships(3, 14:15) = bot_ship_sprite;
ships(2, 16) = bot_ship_sprite;

ships(7, 12:15) = [22, 5, 18, 20];
ships(8, 12:15) = [8, 15, 18, 26];


% When placing ships, a hit sprite to show how to click

hit_for_place = blank_sprite * ones(10, 16);
hit_for_place(1, 12:16) = hit_sprite;

% Where the users ship placements are recorded

ship_place = zeros(10,10);


%Play again board

play_again_board = metal_brick * ones(7,7);


% Words for the "play again?" screen, overlaps with play_again_board
words2 = blank_sprite * ones(7,7);

words2(2, 2:5) = [16, 12, 1, 25];
words2(3, 2:6) = [1, 7, 1, 9, 14];
words2(5, 2:6) = [12, 1, 20, 5, 18];


%Game board display
board_display2 = water_sprite * ones(10,21);
board_display2(:,11) = blank_sprite;


%Hit and Miss display, overlaps with board_display2

hit_miss_display = blank_sprite * ones(10,21);
hit_miss_display(:, 11) = blank_sprite;




wholeGame = 0;

while wholeGame == 0          % Start screen
    gameStarted = false;
        while(~gameStarted)       
             drawScene(start_scene, board_display1, words)      %Drawing the main screen where player can "play" or "quit"
             [r, c] = getMouseInput(start_scene);
             if r == 5 && (c>=4 && c<=7)     %If the user clicks here, the game will start and some variables will be initalized
                 gameStarted = true;      
                 play_Again = true;
                 game = false;
                 cow = 1;
                 k = 3;
                 i = 0;
                 last_hitr1 = 0;
                 last_hitc1 = 0;
                 drawScene(start_scene, ships)
             elseif r == 7 && (c>=4 && c<=7)     %If the player clicks here, the game will close
                 wholeGame = 1;
                 play_Again = false;
                 gameStarted = true;
                 close all
             end
        end

%         while play_Again == true
            ship5_placed = false;
            
%             try_right = 0;    % Smart AI variables. Up here so playing again works
%             try_left = 0;
%             try_up = 0;
%             try_down = 0;
                                
                                                             
            while game == false    
                drawScene(start_scene, ships, hit_for_place)    %Draw the scene for placing ships
                while ship5_placed == false    
                    while k >= 0
                        [r,c] = getMouseInput(start_scene);

                        if r == 7 && (c>=12 && c<=15)     %If the player clicks the "VERT" a vertial ship can be placed 
                            [r,c] = getMouseInput(start_scene);
                            if r <= (6 + i)
                                ships(r,c) = top_ship_sprite;       %The "ships" displays the ship placement to the user
                                board_display2(r,c) = top_ship_sprite;      
                                ships((r+1):(r+k), c) = vert_ship_sprite;   %The "board_display2" records and will display 
                                board_display2((r+1):(r+k), c) = vert_ship_sprite;   %the usersship placements when the game has started
                                ships(r+(k+1), c) = bot_ship_sprite;
                                board_display2(r+(k+1), c) = bot_ship_sprite;
                                drawScene(start_scene, ships, hit_for_place)
                                ship_place(r:(r+k+1), c) = 5;
                                if k == 1 && cow == 1   %This will allow for two, three long ships to be placed
                                    cow = cow + 1;
                                elseif k ~= 1      %If the ship placed isn't a three long, make the next ship smaller 
                                    k = k - 1;
                                    i = i + 1;
                                elseif k == 1 && cow == 2   %Allows for a ship that is two long to be placed
                                    k = k - 1;
                                    i = i + 1;
                                end
                            end
                        end

                        if r == 8 && (c>=12 && c<=15)       %If the user click "HORZ," a horizontal ship can be placed
                            [r,c] = getMouseInput(start_scene);
                            if c <= (6 + i)
                                ships(r,c) = left_ship_sprite;
                                board_display2(r,c) = left_ship_sprite;    %Code is the same as vertical, just horizontal
                                ships(r, (c+1):(c+k)) = horiz_ship_sprite;
                                board_display2(r, (c+1):(c+k)) = horiz_ship_sprite;
                                ships(r, c+(k+1)) = right_ship_sprite;
                                board_display2(r, c+(k+1)) = right_ship_sprite;
                                drawScene(start_scene, ships, hit_for_place)
                                ship_place(r, c:(c+k+1)) = 5;
                                if k == 1 && cow == 1
                                    cow = cow + 1;
                                elseif k ~= 1
                                    k = k - 1;
                                    i = i + 1;
                                elseif k == 1 && cow == 2
                                    k = k - 1;
                                    i = i + 1;
                                end
                            end
                        end
                    end
                    ship5_placed = true;
                end
                game = true;
            end

            locations = Setup();    %Gives the computer random ship locations 

            player_hit = 0;    % Variables needed to start the game
            computer_hit = 0;
            comp_sheet = zeros(10,10);
            gameDone = false;
            player_turn = true;
            ships(7, 12) = hit_sprite;
            ships(8, 12) = miss_sprite;

            direction = 0;
            consecutive_hits = 0;
            intial_c = 0;
            intital_r = 0;
            search_count = 0;
            return_to_initial = false;


            while gameDone == false      % Game starts

                while player_turn == true       % Users turn   
                    drawScene(start_scene, board_display2, hit_miss_display)
                    [r, c] = getMouseInput(start_scene);
                    if c>=12 && c<=21      %If the user clicks on the right board
                        if locations(r, (c-11)) ~= 0
                            hit_miss_display(r,c) = hit_sprite;   %Checks "locations" to find if the input is a hit or miss
                            player_hit = player_hit + 1;
                        elseif locations(r, (c-11)) == 0
                            hit_miss_display(r,c) = miss_sprite;
                        end
                        drawScene(start_scene, board_display2, hit_miss_display)
                    end
                    player_turn = false;
                end

                if player_hit == 17   %Check if user won 
                    player_turn = false;
                    gameDone = true;
                elseif player_hit < 17 %If not, the game continues 
                    player_turn = true;
                end

                comp_turn = false;
                pause(1.5)


                if player_turn == true     %Computers turn
                    
                        [ai_r, ai_c, direction, comp_sheet] = AI(ship_place, comp_sheet, [last_hitr1, last_hitc1], direction)
                        
                        % HIT
                        if(ship_place(ai_r, ai_c) > 0)

                            hit_miss_display(ai_r, ai_c) = hit_sprite;
                            computer_hit = computer_hit + 1;
                            comp_sheet(ai_r, ai_c) = 2;
                            
                            last_hitr1 = ai_r;
                            last_hitc1 = ai_c;
                            consecutive_hits = consecutive_hits + 1;
                            
                            % save initial hit position so that AI can return to it
                            if(consecutive_hits == 1)
                                initial_r = ai_r;
                                initial_c = ai_c;
                            end

                        % MISS
                        else
                            hit_miss_display(ai_r, ai_c) = miss_sprite;
                            comp_sheet(ai_r, ai_c) = 1;

                            dist = distance(ai_r, ai_c, last_hitr1, last_hitc1);

                            if(dist ~= 1)
                                consecutive_hits = 0;
                            end
                            fprintf("consecutive_hits: %i\n", consecutive_hits)
                            
                            if(consecutive_hits > 1)
                                if(~return_to_initial)
                                    return_to_initial = true;
                                else
                                    return_to_initial = false;
                                end

                                % change direction (face opposite direction)
                                for i = 1:2
                                    if(direction == 4)
                                        direction = 1;
                                    else
                                        direction = direction + 1;
                                    end
                                end

                                if(((initial_r > 1 && initial_r < 10) && (initial_c > 1 && initial_c < 10)) && return_to_initial)
                                    last_hitr1 = initial_r;
                                    last_hitc1 = initial_c;
                                end
                            % testing shots (firing around to last hit location)
                            elseif(consecutive_hits == 1)
                                if(direction == 4)
                                    direction = 1;
                                else
                                    direction = direction + 1;
                                end
                            else
                                last_hitr1 = 0;
                                last_hitc1 = 0;
                            end
                        end
                        fprintf("(%i, %i)\n", last_hitr1, last_hitc1)

                    drawScene(start_scene, board_display2, hit_miss_display)
                    player = false;
                end

                if computer_hit == 17       %Check if computer won
                    player = true;
                    gameDone = true;
                elseif computer_hit < 17  %If not, the game contunues
                    player = false;
                end

                pause(1.5)

            end


            drawScene(start_scene, play_again_board, words2)   %Play again?
            [r,c] = getMouseInput(start_scene);
            if (r == 2 && (c>=2 && c>=5)) || (r==3 && (c>=2 && c<=6))   %If user clicks here, the game will go again
                play_Again = true;
                play_again_final = true;
                wholeGame = 1;
            elseif r == 5 && (c>=2 && c<=6)  %Otherwise the user will be brought to the main screen where they can then "quit" the game
                play_Again = false;
                play_again_final = false;
                close all
                wholeGame = 1;
            end

        end
end
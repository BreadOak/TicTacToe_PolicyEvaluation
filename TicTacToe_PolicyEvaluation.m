clear all
clc

global number_of_states
global number_of_actions
global discount_rate
global learning_rate

number_of_states = 3^9;
number_of_actions = length([1 2 3 4 5 6 7 8 9]);
discount_rate = 1;
learning_rate = 1;

turn = 1;
play_number = 1*10^4;
episodes = get_tic_tac_toe_eps(play_number,turn);

action_value_by_MC = policy_evaluation_by_MC(episodes);
mc1 = action_value_by_MC(1,1); % (state, action)
mc2 = action_value_by_MC(1,2); % (state, action)
mc3 = action_value_by_MC(1,3); % (state, action)
mc4 = action_value_by_MC(1,4); % (state, action)
mc5 = action_value_by_MC(1,5); % (state, action)
mc6 = action_value_by_MC(1,6); % (state, action)
mc7 = action_value_by_MC(1,7); % (state, action)
mc8 = action_value_by_MC(1,8); % (state, action)
mc9 = action_value_by_MC(1,9); % (state, action)

%sum(sum(action_value_by_MC))
First_visit_MC_policy_evaluation = [mc1 mc2 mc3; 
                                    mc4 mc5 mc6; 
                                    mc7 mc8 mc9]

action_value_by_TD0 = policy_evaluation_by_TD0(episodes);
TD0_1 = action_value_by_TD0(1,1); % (state, action)
TD0_2 = action_value_by_TD0(1,2); % (state, action)
TD0_3 = action_value_by_TD0(1,3); % (state, action) 
TD0_4 = action_value_by_TD0(1,4); % (state, action)
TD0_5 = action_value_by_TD0(1,5); % (state, action)
TD0_6 = action_value_by_TD0(1,6); % (state, action)
TD0_7 = action_value_by_TD0(1,7); % (state, action)
TD0_8 = action_value_by_TD0(1,8); % (state, action)
TD0_9 = action_value_by_TD0(1,9); % (state, action)

%sum(sum(action_value_by_TD0))
TD_zero_policy_evaluation = [TD0_1 TD0_2 TD0_3;
                             TD0_4 TD0_5 TD0_6;
                             TD0_7 TD0_8 TD0_9]

%% get episodes from tic-tac-toe games
function eps = get_tic_tac_toe_eps(n,turn)
    eps = cell(1,n,1);
    for i = 1:n
        ep = get_tic_tac_toe_ep(turn);
        eps{i} = ep;                
    end
end

%% get episode from tic-tac-toe game
function ep = get_tic_tac_toe_ep(turn)

    board_state = zeros(3,3);    
    s = (board_state);
    a = [];
    r = [];
    player_action = [1 2 3 4 5 6 7 8 9];
    
    %%%%%%%%%% if player1 is first turn %%%%%%%%%% 
    
    if turn == 1
        first_check_number = 1;
        second_check_number = 2;
        
    %%%%%%%%%% if player2 is first turn %%%%%%%%%%     
    elseif turn ==  2
        first_check_number = 2;
        second_check_number = 1;
    end
    
    count = 0;
    while(1)              
        %%% first player's turn %%%
        
        % make random action
        if length(player_action) == 1
            random_action = player_action;
            player_action = [];
                
        else
            random_action = randsample(player_action,1);
             for i = length(player_action) : -1: 1
                if player_action(i) == random_action
                   player_action(i) = [];
                end     
            end 
        end
            
        % add new action
        a = [random_action 0 0; 0 0 0; 0 0 0];
            
        pos = board_position(random_action);
        board_state(pos(1), pos(2)) = first_check_number;
                     
        check = check_point(board_state);
            
        % add new reward
        r = [check(1) 0 0; 0 0 0; 0 0 0];
        
        set = {s, a, r};

        if count == 0
            sets = {set};
        else
            sets = { sets{1:end}, set };
        end
        
        % add new state 
        s = board_state;
        
        %%% player1 win or player2 win or draw %%% 
        if check(1) == 1 || check(2) == 2 || isempty(player_action) ==1
            ep = sets;  %return episode
            break
        end 
        count = count + 1;
        
        %%% second player's turn %%%
            
        % make random action
        if length(player_action) == 1
            random_action = player_action;
            player_action = [];
            
        else
            random_action = randsample(player_action,1);
            for i = length(player_action) : -1: 1
                if player_action(i) == random_action
                   player_action(i) = [];
                end     
            end 
        end          
            
        % add new action
        a = [random_action 0 0; 0 0 0; 0 0 0];
        
        pos = board_position(random_action);
        board_state(pos(1), pos(2)) = second_check_number;
                
        check = check_point(board_state);
            
        % add new reward
        r = [check(1) 0 0; 0 0 0; 0 0 0];
        
        set = {s, a, r};

        if count == 0
            sets = {set};
        else
            sets = { sets{1:end}, set };
        end
        
        % add new state
        s = board_state;
            
        %%% player1 win or player2 win or draw %%% 
        if check(1) == 1 || check(2) == 2 || isempty(player_action) ==1
            ep = sets;  %return episode       
            break
        end       
        count = count + 1; 
    end
end

%% return board position of action
function pos = board_position(number)
    pos = zeros(1,2);
    if number == 1
        raw = 1;
        col = 1;
    elseif number == 2
        raw = 1;
        col = 2;
    elseif number == 3
        raw = 1;
        col = 3;
    elseif number == 4
        raw = 2;
        col = 1;
    elseif number == 5
        raw = 2;
        col = 2;    
    elseif number == 6
        raw = 2;
        col = 3;
    elseif number == 7
        raw = 3;
        col = 1;
    elseif number == 8
        raw = 3;
        col = 2;
    elseif number == 9
        raw = 3;
        col = 3;
    end
    pos(1) = raw;
    pos(2) = col;
end

%% return board number to position
function num = board_number(pos)
    num = 0;
    if pos(1) == 1 && pos(1) == 1
        num = 1;
    elseif pos(1) == 1 && pos(2) == 2
        num = 2;
    elseif pos(1) == 1 && pos(2) == 3
        num = 3;
    elseif pos(1) == 2 && pos(2) == 1
        num = 4;
    elseif pos(1) == 2 && pos(2) == 2
        num = 5;
    elseif pos(1) == 2 && pos(2) == 3
        num = 6;
    elseif pos(1) == 3 && pos(2) == 1
        num = 7;
    elseif pos(1) == 3 && pos(2) == 2
        num = 8;
    elseif pos(1) == 3 && pos(2) == 3
        num = 9;
    end    
end

%% check win or lose or draw
function result = check_point(board) 

    result = [];
    for i = 1:2
        for j = 1:3
                       
            % col complete
            if board(1,j)==i && board(2,j)==i && board(3,j)==i 
                
                if i ==1
                    result = [1,1];
                    break
                elseif i ==2
                    result = [0,2];
                    break
                end
                
            % raw complete
            elseif board(j,1)==i && board(j,2)==i && board(j,3)==i 
                
                if i ==1
                    result = [1,1];
                    break
                elseif i ==2
                    result = [0,2];
                    break
                end
            
            % diag1 complete
            elseif board(1,1)==i && board(2,2)==i && board(3,3)==i 
                
                if i ==1
                    result = [1,1];
                    break
                elseif i ==2
                    result = [0,2];
                    break
                end
                
            % diag2 complete
            elseif board(3,1)==i && board(2,2)==i && board(1,3)==i 
                
                if i ==1
                    result = [1,1];
                    break
                elseif i ==2
                    result = [0,2];
                    break
                end
            end
        end
    end
    
    if isempty(result)
        result = [0,0];
    end
    
end

%% match state matrix to state number
function s_num = match_state_mat2num(s_matrix)
 
    count = 0;
    s_num = 0;
    
    for i = 0:2
        for h = 0:2
            for g = 0:2
                for f = 0:2
                    for e = 0:2
                        for d = 0:2
                            for c = 0:2
                                for b = 0:2
                                    for a = 0:2  
                                        
                                        count = count + 1;              
                                        compare_matrix = [a b c; d e f; g h i];
                                        
                                        if isequal(compare_matrix, s_matrix)
                                            s_num = count;
                                        end        
                                        
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
end

%% compute action value function using first-visit MC prediction for a given list of episodes.
function value_fn = policy_evaluation_by_MC(episodes)

    global number_of_states
    global number_of_actions
    value_fn = zeros(number_of_states,number_of_actions);
    counts = zeros(number_of_states,number_of_actions);
    
    for i = 1:length(episodes)    
        episode = episodes{i};
         
        G_N = policy_evaluation_for_episode_by_MC(episode);
        
        G = G_N{1}; 
        N = G_N{2};
        counts = counts + N;
        for state = 1 : number_of_states
            for action = 1 : number_of_actions

                value_fn(state, action) = value_fn(state,action) * counts(state,action) + G(state,action);
                value_fn(state, action) = value_fn(state,action)/(counts(state,action) + 1);
                
            end
        end
    end
end

%% compute action value function using first-visit MC prediction for a given episode.
function G_N = policy_evaluation_for_episode_by_MC(episode) 

    global number_of_states
    global number_of_actions
    global discount_rate
    G = 0;
    episode = flip(episode);
    
    returns = zeros(number_of_states, number_of_actions); % number of states and number of actions
    counts = zeros(number_of_states, number_of_actions);  % number of states and number of actions

    for i= 1 : length(episode)
        
        % state, action, reward(matrix)
        s_matrix = episode{i}{1};
        a_matrix = episode{i}{2};
        r_matrix = episode{i}{3};
        
        % state, action, reward(matrix -> number)
        s = match_state_mat2num(s_matrix);
        a = a_matrix(1,1);
        r = r_matrix(1,1);
        
        G = discount_rate * G + r; % update return
          
        %%%% check if s,a, are the first visit %%%
        
        pair_list = [];
        
        for j = i+1 : length(episode)
            
            step = episode{j};
      
            step_state_matrix = step{1};
            step_action_matrix = step{2};
            
            step_state = match_state_mat2num(step_state_matrix);
            step_action = step_action_matrix(1,1);
            
            if step_state == s && step_action == a
                
                pair = [step_state, step_action];
                pair_list = [pair_list, pair];
       
            end
            
        end
        
        find_sa_pair = isempty(pair_list);
        
        if find_sa_pair
            returns(s,a) = G;
            counts(s,a) = counts(s,a) + 1;
        end
        %%%% check if s,a, are the first visit %%%
        
    G_N = {returns, counts};
    
    end
end

%% compute action value function using TD(0) prediction for a given list of episodes.
function value_fn = policy_evaluation_by_TD0(episodes)
    global discount_rate
    global number_of_states
    global number_of_actions
    global learning_rate
    value_fn = zeros(number_of_states,number_of_actions);
    
    for j = 1:length(episodes)
        episode = episodes{j};
        S_A_R = policy_evaluation_for_episode_by_TD0(episode);
        s_trajectory = S_A_R{1};
        a_trajectory = S_A_R{2};
        r_trajectory = S_A_R{3};
    
        terminal_state = s_trajectory(end);
        t = 0;
        
        while(1)       
            t = t + 1;
            state = s_trajectory(t);
            if state == terminal_state
                next_state = 3^9;
            else
                next_state = s_trajectory(t + 1);
            end
            action = a_trajectory(t);
            reward = r_trajectory(t);
            next_value_fn = sum(value_fn,2)./9;
            %value_fn(state,action) = value_fn(state,action) + learning_rate * (reward + discount_rate * value_fn(next_state, action) - value_fn(state,action));
            value_fn(state,action) = value_fn(state,action) + learning_rate * (reward + discount_rate * next_value_fn(next_state) - value_fn(state,action));
            if state == terminal_state
                break
            end
        end
    end
end

%% compute action value function using TD(0) prediction for a give episode.
function S_A_R = policy_evaluation_for_episode_by_TD0(episode)
    state_trajectory = [];
    action_trajectory = [];
    reward_trajectory = [];
    
    for i = 1:length(episode)
        % state, action, reward(matrix)
        s_matrix = episode{i}{1};
        a_matrix = episode{i}{2};
        r_matrix = episode{i}{3};
        
        % state, action, reward(matrix -> number)
        s = match_state_mat2num(s_matrix);
        a = a_matrix(1,1);
        r = r_matrix(1,1);
        state_trajectory = [state_trajectory, s];
        action_trajectory = [action_trajectory, a];
        reward_trajectory = [reward_trajectory, r];
    end
    S_A_R = {state_trajectory, action_trajectory, reward_trajectory};
end

while(1)

clear;
teamFolder = 'C:\Users\User\Google Drive (games.earena@gmail.com)\Teams';
rankFolder = 'C:\Users\User\Google Drive (games.earena@gmail.com)\General';

files = dir(teamFolder);
teamNames = {files([files.isdir]).name};
teamNames = teamNames(~ismember(teamNames,{'.','..'}));

    ranking = [];
    team_distance = 0.0;
    team_soc = 0.0;
    Team = [];
    Distance = [];
    SoC = [];
    for team=teamNames
        files = dir(fullfile(teamFolder, team{1}));
        tasks = {files([files.isdir]).name};
        tasks = tasks(~ismember(tasks, {'.', '..'}));
        team_soc = 0.0;
        team_distance = 0.0;
        for task=tasks
            delete(fullfile('solution', '*'));
            delete('*.mexw64');
            if (strcmp('task1x', task{1}) == 1)
                disp('Evaluating first task...');
                srcs = dir(fullfile(teamFolder, team{1}, task{1}));
                srcs = {srcs(~[srcs.isdir]).name};
                if isempty(srcs)
                    continue;
                end
                for src=srcs
                    path = fullfile(teamFolder, team{1}, task{1}, src);
                    copyfile(path{1}, 'solution');
                end
                try
                    sim('stem_processor');
                catch ex
                    status = rmdir(fullfile(teamFolder, team{1}, task{1}, 'results'), 's');
                    mkdir(fullfile(teamFolder, team{1}, task{1}, 'results'));
                    fid = fopen(fullfile(teamFolder, team{1}, task{1}, 'results', 'log.txt'), 'w');
                    fprintf(fid, "Compilation error at: %s", datestr(datetime('now')));
                    continue;
                end
                f = figure('visible','off');
                plot(tout, simout.Data);
                mkdir(fullfile(teamFolder, team{1}, task{1}, 'results'));
                saveas(f,fullfile(teamFolder, team{1}, task{1}, 'results', 'gpio-port'),'png');
            elseif (strcmp('task2x', task{1}) == 1)
                disp('Evaluating second task...');
                srcs = dir(fullfile(teamFolder, team{1}, task{1}));
                srcs = {srcs(~[srcs.isdir]).name};
                if isempty(srcs)
                    continue;
                end
                for src=srcs
                    path = fullfile(teamFolder, team{1}, task{1}, src);
                    copyfile(path{1}, 'solution');
                end
                try
                    init_day_2;
                    data = sim('top1');
                catch ex
                    rmdir(fullfile(teamFolder, team{1}, task{1}, 'results'), 's');
                    mkdir(fullfile(teamFolder, team{1}, task{1}, 'results'));
                    fid = fopen(fullfile(teamFolder, team{1}, task{1}, 'results', 'log.txt'), 'w');
                    fprintf(fid, "Compilation error at: %s", datestr(datetime('now')));
                    continue;
                end
                mkdir(fullfile(teamFolder, team{1}, task{1}, 'results'));
                f = figure('visible','off');
                plot(data.tout, data.sim_speed);
                xlabel('time (s)');
                ylabel('speed (m/s)');
                saveas(f,fullfile(teamFolder, team{1}, task{1}, 'results', 'speed'),'png');
                f = figure('visible','off');
                plot(data.tout, data.sim_gpio.Data);
                xlabel('time (s)');
                ylabel('GPIO\_DATA');
                saveas(f,fullfile(teamFolder, team{1}, task{1}, 'results', 'gpio'),'png');
                f = figure('visible','off');
                plot(data.tout, data.sim_dac.Data);
                xlabel('time (s)');
                ylabel('DAC\_DATA');
                saveas(f,fullfile(teamFolder, team{1}, task{1}, 'results', 'dac'),'png');
            elseif (strcmp('task3', task{1}) == 1)
                disp('Evaluating third task...');
                srcs = dir(fullfile(teamFolder, team{1}, task{1}));
                srcs = {srcs(~[srcs.isdir]).name};
                if isempty(srcs)
                    continue;
                end
                for src=srcs
                    path = fullfile(teamFolder, team{1}, task{1}, src);
                    copyfile(path{1}, 'solution');
                end
                try
                    init_day_2_1;
                    data = sim('top2');
                catch ex
                    rmdir(fullfile(teamFolder, team{1}, task{1}, 'results'), 's');
                    mkdir(fullfile(teamFolder, team{1}, task{1}, 'results'));
                    fid = fopen(fullfile(teamFolder, team{1}, task{1}, 'results', 'log.txt'), 'w');
                    fprintf(fid, "Compilation error at: %s", datestr(datetime('now')));
                    continue;
                end
                mkdir(fullfile(teamFolder, team{1}, task{1}, 'results'));
                f = figure('visible','off');
                plot(data.tout, data.sim_speed);
                xlabel('time (s)');
                ylabel('speed (m/s)');
                saveas(f,fullfile(teamFolder, team{1}, task{1}, 'results', 'speed'),'png');
                f = figure('visible','off');
                plot(data.tout, data.sim_gpio.Data);
                xlabel('time (s)');
                ylabel('GPIO\_DATA');
                saveas(f,fullfile(teamFolder, team{1}, task{1}, 'results', 'gpio'),'png');
                f = figure('visible','off');
                plot(data.tout, data.sim_dac.Data);
                xlabel('time (s)');
                ylabel('DAC\_DATA');
                saveas(f,fullfile(teamFolder, team{1}, task{1}, 'results', 'dac'),'png');
                f = figure('visible','off');
                plot(data.tout, data.sim_y.Data);
                xlabel('time (s)');
                ylabel('y(t) (m)');
                saveas(f,fullfile(teamFolder, team{1}, task{1}, 'results', 'elevation'),'png');
                team_distance = data.sim_x.Data(end);
                team_soc      = data.sim_soc.Data(end);
            end
        end
        Team = [Team; team];
        Distance = [Distance; team_distance];
        SoC = [SoC; team_soc];
    end
    Distance = (Distance - min(Distance))/(max(Distance) - min(Distance));
    Points = Distance * 0.5 + SoC * 0.75;
    T = table(Team, Points);
    T = sortrows(T, 2, 'descend');
    delete(fullfile(rankFolder, 'rank.xlsx'));
    writetable(T, fullfile(rankFolder, 'rank.xlsx'), 'Sheet', 1);
end
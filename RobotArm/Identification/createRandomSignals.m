function [time, base, rot, trans1, trans2, pulley] = createRandomSignals(simTime, Ts)

    deltaT = 5;
    t = 0;
    distribution = [0.8, 0.05, 0.05]; % step, ramp, sin
    
    
    base = [0];
    rot = [0];
    trans1 = [0];
    trans2 = [0];
    pulley = [0];
    lastValue = [0, 0, 0, 0, 0];
    time = [0];
    while t <= simTime
        linT = linspace(Ts, deltaT, round(deltaT/Ts));
        time = [time, t + linT];
        t = t + deltaT; 
        % base 
        A = randi([-deltaT, deltaT]) * 40;
        if abs(lastValue(1) + A) <= 250
            randNum = rand(1);
            if randNum < distribution(1) % step
                base = [base, lastValue(1) + ones([1, round(deltaT/Ts)])*A];
            elseif randNum < sum(distribution(1:2)) % ramp
                base = [base, lastValue(1) + (linT)];
            else % sin
                base = [base, lastValue(1) + A*sin(linT)];
            end
        else
            base = [base, zeros([1, round(deltaT/Ts)])];
        end
        lastValue(1) = base(end);
        
        
        % pulley 
        if t > 50
            A = randi([-deltaT, deltaT]) * 30;
        else
            A = randi([0, deltaT]) * 30;
        end
        randNum = rand(1);
        if abs(lastValue(2) + A) <= 180
            if randNum < distribution(1) % step
                pulley = [pulley, lastValue(2) + ones([1, round(deltaT/Ts)])*A];
            elseif randNum < sum(distribution(1:2)) % ramp
                pulley = [pulley, lastValue(2) + (linT)];
            else % sin
                pulley = [pulley, lastValue(2) + A*sin(linT)];
            end
            lastValue(2) = pulley(end);
            
        else
            pulley = [pulley, zeros([1, round(deltaT/Ts)])];
        end
        
        randNum = randi([1, 3]);
        if randNum == 1
            % rot 
            A = (2*round(rand(1))-1) * 0.05;
            if lastValue(3) + A*deltaT > 0 && lastValue(3) + A*deltaT < 0.9 
                rot = [rot, ones([1, round(deltaT/Ts)])*A];
                lastValue(3) = lastValue(3) + A*deltaT;
            else
                rot = [rot, zeros([1, round(deltaT/Ts)])];
            end
            trans1 = [trans1, zeros([1, round(deltaT/Ts)])];
            trans2 = [trans2, zeros([1, round(deltaT/Ts)])];
        elseif randNum == 2
            % trans1
            A = (2*round(rand(1))-1) * 0.05;
            if lastValue(4) + A*deltaT > 0 && lastValue(4) + A*deltaT < 0.9 
                trans1 = [trans1, ones([1, round(deltaT/Ts)])*A]
                lastValue(4) = lastValue(4) + A*deltaT;
            else
                trans1 = [trans1, zeros([1, round(deltaT/Ts)])];
            end
            rot = [rot, zeros([1, round(deltaT/Ts)])];
            trans2 = [trans2, zeros([1, round(deltaT/Ts)])];
        elseif randNum == 3
            % trans2
            A = (2*round(rand(1))-1) * 0.05;
            if lastValue(5) + A*deltaT > 0 && lastValue(5) + A*deltaT < 0.9 
                trans2 = [trans2, ones([1, round(deltaT/Ts)])*A]
                lastValue(5) = lastValue(5) + A*deltaT;
            else
                trans2 = [trans2, zeros([1, round(deltaT/Ts)])];
            end
            rot = [rot, zeros([1, round(deltaT/Ts)])];
            trans1 = [trans1, zeros([1, round(deltaT/Ts)])];
        end

    end

end
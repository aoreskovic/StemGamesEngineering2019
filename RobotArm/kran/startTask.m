function done = startTask(task)
    
    if task == 1
        set_param('kran/isIdentification','Value', '0')
        sim('kran.slx')
        done = 1;
        
    end
    

end


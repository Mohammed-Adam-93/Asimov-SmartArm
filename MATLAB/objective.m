function cost = objective(q, desiredT)
    
    currentT = transform(q);

    error = currentT - desiredT;

    cost = sum(error(:).^2);
end













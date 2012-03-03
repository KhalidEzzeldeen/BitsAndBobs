function out = DeltaPlot(t_int, plot)

Delta = inline('2*(t>4).*(1-abs(t-5)).*(t<6)','t');
switch plot
    case 0
        out = Delta(t_int);
    case 1
        figure;
        title('\fontsize{14} Plot of Delta Function from (8)');
        xlabel('\fontsize{13} Time');
        ylabel('\fontsize{13} Delta Value');
        hold on;
        plot(t_int, Delta(t_int));
        hold off;
        out=[];
end
%% Response time, plot and regression
RT2back=marker.P_hit{2}-marker.L_hit{2};
time2back=(marker.L_hit{2}-marker.L_hit{2}(1))./1000;
time3back=(marker.L_hit{1}-marker.L_hit{1}(1))./1000;
RT3back=marker.P_hit{1}-marker.L_hit{1};

hold on
plot(time2back,RT2back,'*')
box off
plot(time3back,RT3back,'*')

title('Response time')
legend({'3back','2back'})
ax=gca;
col2back=ax.Children(2).Color;
col3back=ax.Children(1).Color;
%%
p2=polyfit(time2back,RT2back,1);
RT2rec = polyval(p2,time2back);
  
p3=polyfit(time3back,RT3back,1);
RT3rec = polyval(p3,time3back);

b2back=time2back\RT2back;
b3back=time3back\RT3back;

plot(time2back,RT2rec,'Color',col2back)
plot(time3back,RT3rec,'Color',col3back)
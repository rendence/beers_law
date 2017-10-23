 CO2run(:,5)=((CO2run(:,4)./CO2run(:,3))./(.0111/.9842)-1)*1000;
 allan_var_plot(CO2run(5500:8000,5),CO2run(5500:8000,2))
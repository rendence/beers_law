T=PTE.txt;
k=700/1000;
for j=1:14000
    wave(j,1)=T(j,5)+T(j,6)*k+T(j,7)*k^2 +T(j,8)*exp(k/T(j,9));
    tune(j,1)=T(j,6)+2*T(j,7)*k-(T(j,8)/T(j,9))*exp(k/T(j,9));
end



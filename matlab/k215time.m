%
%
% 2/15ths law: time and angle averaged 
%
%
mu=0;
ke=0;
nx=1;
delx_over_eta=1;
eta = 1/(nx*delx_over_eta);
ext='.isostr';

name = '/home/skurien/helicity_data/check256_hq_';

[avg_eps, avg_heps, avg_delx_over_eta] = ensemble_avg_params

nx=256; delx_over_eta=avg_delx_over_eta; epsilon=avg_eps; h_epsilon=avg_heps;  
teddy=1;
ext='.new.isostr';
times=[0:1:30];


ndir_use=0;
%ndir_use=49;  disp('USING ONLY 49 DIRECTIONS')

% this type of averging is expensive:
time_and_angle_ave=1;

k=0;




xx=(1:.5:(nx./2.5)) / nx;
xx_plot=(1:.5:(nx./2.5)) *delx_over_eta;   % units of r/eta

y215_ave=zeros([length(xx),73]);
if (time_and_angle_ave==1) 
   y215_iso_ave=zeros([length(xx),1]);
end

times_plot=[];
for t=times
  tstr=sprintf('%10.4f',t+10000);
  fname=[name,tstr(2:10)];
  disp([fname,ext]);
  fid=fopen([fname,ext]);
  if (fid<0) ;
    disp('error openining file, skipping...');
  else
    fclose(fid);
    times_plot=[times_plot,t];
    k=k+1;

    if (time_and_angle_ave==1) 
      klaws=3;                          % compute 2/15 laws
      plot_posneg=0;
      check_isotropy=0;
      
      [y45,y415,y43,eps,h_eps,y215]=compisoave(fname,ext,xx,ndir_use,klaws,plot_posneg,check_isotropy,0);
      
      
      mx215_iso_localeps(k)=max(y215);
      mx215_iso(k)=max(y215)*eps/epsilon;
      
      y215_iso_ave=y215_iso_ave+y215';
      
    end    


    [nx,ndelta,ndir,r_val,ke,eps_l,mu,tmp,tmp,tmp,tmp,tmp,tmp,tmp,...
    tmp,tmp,tmp,tmp,tmp,H_ltt,H_tt,tmp,tmp,tmp,h_eps_l] ...
        = readisostr( [fname,ext] );
    
    eta_l = (mu^3 / eps_l)^.25;
    delx_over_eta_l=(1/nx)/eta_l;

    
    for dir=1:73;
      x=r_val(:,dir)/nx;                % box length
      y=-H_ltt(:,dir)./(x.^2*abs(h_eps_l)/2);
      
      y215 = spline(x,y,xx);
      
      mx215_localeps(k,dir)=max(y215);
      mx215(k,dir)=max(y215)*h_eps_l/h_epsilon;
      
      y215_ave(:,dir)=y215_ave(:,dir)+y215';
    end
  end

end

times=times_plot;
y215_ave=y215_ave/length(times);
y215_iso_ave=y215_iso_ave/length(times);

if (0)

% averging starting at t=0:
save k215data_t0 teddy times mx215_localeps mx215_iso_localeps ...
      y215_ave y215_iso_ave xx_plot

% averging starting at t=1:
save k215data_t1 teddy times mx215_localeps mx215_iso_localeps ...
      y215_ave y215_iso_ave xx_plot

% load data from t=0 (averaged wrong!) for isoave paper:
load k215data_t0 

% load data from t=1 (for time averaged) for isoave paper:
load k215data_t1 
end


figure(5); clf; hold on; 
for i=2:2
%   plot(times/teddy,mx215_localeps(1:length(times),i),'k:','LineWidth',2.0);
   plot(times/teddy,mx215_localeps(1:length(times),i),'g-','LineWidth',2.0);
end
%plot(times/teddy,mx215_iso_localeps,'k-','LineWidth',2.0);
plot(times/teddy,mx215_iso_localeps,'b-','LineWidth',2.0);
ax=axis;
axis( [ax(1),ax(2),.5,1.0] );
plot(times,(2/15)*times./times,'k');
hold off;
ylabel(' < (u(x+r)-u(x))^3 > / (\epsilon r)','FontSize',16);
xlabel('time','FontSize',16)
print -dpsc k215time.ps


figure(6); clf

for i=[1:1:31]
  %semilogx(xx_plot,y215_ave(:,i),'k:','LineWidth',2.0); hold on
  semilogx(xx_plot,-(y215_ave(:,i)),'r-','LineWidth',2.0); hold on
end
%semilogx(xx_plot,y215_iso_ave,'k','LineWidth',2.0); hold on
semilogx(xx_plot,y215_iso_ave,'b','LineWidth',2.0); hold on
axis([1 1000 0 1.0])
x=1:1000; plot(x,(2/15)*x./x,'k');
hold off;
title('H_{ltt} / r^2\h_{epsilon}   (2/15 law) ');
ylabel('H_{ltt}/h_{epsilon}r^2','FontSize',16);
xlabel('r/\eta','FontSize',16);

print -dpsc k215mean.ps



figure(7); clf
offset=y215_iso_ave;
stdr=0*offset;

for i=[1:1:31]
  %semilogx(xx_plot,y215_ave(:,i)-offset,'k:','LineWidth',2.0); hold on
  semilogx(xx_plot,-y215_ave(:,i)-offset,'k-','LineWidth',2.0); hold on
  stdr=stdr+(y215_ave(:,i)-offset).^2;
end
stdr=sqrt(stdr/15)./offset;
%semilogx(xx_plot,y215_iso_ave-offset,'k','LineWidth',2.0); hold on
semilogx(xx_plot,y215_iso_ave-offset,'b','LineWidth',2.0); hold on
axis([1 1000 -.2 .2])
x=1:1000; plot(x,(2/15)*x./x,'k');
hold off;
%title('H_{ltt} / r^2\h_{\epsilon}   (2/15 law) ');
ylabel('< (u(x+r)-u(x))^3 > / (\epsilon r)','FontSize',16);
xlabel('r/\eta','FontSize',16);






starttime=1;
ln=find(times>=starttime);
ln=ln(1);
lnmax=length(times);

dir_use=2;
[mean(mx215(ln:lnmax,dir_use)),mean(mx215_iso(ln:lnmax))]
[std(mx215(ln:lnmax,dir_use)),std(mx215_iso(ln:lnmax)) ]








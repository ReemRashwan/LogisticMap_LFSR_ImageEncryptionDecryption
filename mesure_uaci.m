function uacii=mesure_uaci(RG,Sim)
uacii=ones(1,3); %%% pour R G B
%UACI(1)   %%%%%%% correspond à R
%UACI(2)   %%%%%%% correspond à G
%UACI(3)   %%%%%%% correspond à B
[lignes,colones]=size(RG(:,:,1));
 siz=colones*lignes;
 
 RGc=double(RG);
 Simc=double(Sim);
for k=1:3
 tt=0;
 for n=1:lignes
    for m=1:colones
       tt=tt+abs(RGc(n,m,k)-Simc(n,m,k)) ;
    end
 end
tt=tt/(siz*255);
uacii(k)=tt*100;
end

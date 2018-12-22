function NPCR=mesure_npcr(RG,Sim)
NPCR=zeros(1,3); %%% pour R G B
%NPCR(1)   %%%%%%% correspond à R
%NPCR(2)   %%%%%%% correspond à G
%NPCR(3)   %%%%%%% correspond à B
[lignes,colones]=size(RG(:,:,1));
 siz=colones*lignes;
 
 for k=1:3
 SSS=0;
for i=1:lignes
    for j=1:colones
         
       if (RG(i,j,k)==Sim(i,j,k))
           SSS=SSS;
       else
           SSS=SSS+1;
       end
    end
end
SSS=SSS/siz;
NPCR(k)=SSS*100;
end
 

clear;
legend=importdata('legend.txt');
cfb=importdata('cfb2014.csv');

fid = fopen('cfb2014.csv');  
A= textscan(fid, '%s %f %s %f','delimiter',',');
team1=A{1};
score1=A{2};
team2=A{3};
score2=A{4};
fclose(fid);
[matches,y]=size(team1);

[teams,y]=size(legend);
M=zeros(teams,teams);
sumRecord=zeros(teams,1);
% char(legend);
% legend;
% whos legend;
% 
% for i=1:759
%     d
% end

for i=1:matches
    %[index1,y]=find(legend(:)==cfb(i,1));
    %[index2,y]=find(legend(:)==cfb(i,3));
    %find(strcmp(A, 'abc'))
    %cfb(i,1);
    %legend=cellstr(legend);
    %whos legend
    name1=char(team1(i));
    name1(find(isspace(name1)))=[];
    %name1='''+name1;
    %prime='\'';
    %name1=['''',name1,'''']
    %str(name1);
    %name1=cell(name1);
    %legend(205)
    %name=0;
    %if (strcmp(legend(205),name1) )
    %    name=1;
    %end
    %name
    [index1,y]=find(strcmp(legend,name1));
    name2=char(team2(i));
    name2(find(isspace(name2)))=[];
    [index2,y]=find(strcmp(legend,name2));
    %team2(i)
    %team2(i)(find(isspace(team2(i))))=[];
    %s(find(isspace(s))) = []
    %cellfun(@(b)hex2dec(b(~isspace(b))),B)
    %name2
    %name2(isspace(name2))=[];
    %name2(name2~=' ');
    %name2~=' ';
    %A= A(find(~isspace(A)))
    %A= A(~isspace(A))
    %name2(find(isspace(name2)))=[];
    %name2(name2~=' ');
    %strtrim(name2);
    %type name2
    %name2=strcat(name2);
    %whos name2
    %name2=char(name2)
    %name2(find(isspace(name2)))=[];
    %name2
    %index2
    %index1
    if (score1(i)>score2(i))
        M(index1,index1)=M(index1,index1)+score1(i)/(score1(i)+score2(i));
        M(index2,index1)=M(index2,index1)+score1(i)/(score1(i)+score2(i));
        sumRecord(index1,1)=sumRecord(index1,1)+score1(i)/(score1(i)+score2(i));
        sumRecord(index2,1)=sumRecord(index2,1)+score1(i)/(score1(i)+score2(i));
    end
    if (score1(i)<score2(i))
        M(index2,index2)=M(index2,index2)+score2(i)/(score2(i)+score1(i));
        M(index1,index2)=M(index1,index2)+score2(i)/(score2(i)+score1(i));
        sumRecord(index1,1)=sumRecord(index1,1)+score2(i)/(score1(i)+score2(i));
        sumRecord(index2,1)=sumRecord(index2,1)+score2(i)/(score1(i)+score2(i));
    end
end

for i=1:teams
    if (sumRecord(i,1)~=0)
        M(i,:)=M(i,:)/sumRecord(i,1);
    end
end

% %check
% rdm=711;
% sum=0;
% for i=1:teams
%     sum=sum+M(rdm,i);
% end
% sum
%M
%tM=transpose(M)

u=zeros(teams,1001);

for j=1:1001
    if (j==1)
        for i=1:teams
            u(i,j)=1/teams;
        end
    end
    if (j~=1)
        u(:,j)=transpose(M)*u(:,j-1);
%         for x=1:teams
%             %u(x,2)
%             for y=1:teams
%                 u(x,j)=u(x,j)+M(y,x)*u(y,j-1);
%             end
%         end
    end
end

%u(:,1001)

% %check
% rdm=711;
% sum=0;
% for i=1:teams
%     sum=sum+u(i,rdm);
% end
% sum

tmpU=u;
    disp('t= 10 : ');
    %disp();
    for i=1:20
        [x,y]=max(tmpU(:,11));
        disp([legend(y),'\t\t',tmpU(y,11)]);
        %disp(tmpU(y,11));
        tmpU(y,11)=0;
    end

tmpU=u;
    disp('t= 100 : ');
    %disp();
    for i=1:20
        [x,y]=max(tmpU(:,101));
        disp([legend(y),'\t\t',tmpU(y,101)]);
        %disp(tmpU(y,11));
        tmpU(y,101)=0;
    end
    
tmpU=u;    
    disp('t= 200 : ');
    %disp();
    for i=1:20
        [x,y]=max(tmpU(:,201));
        disp([legend(y),'\t\t',tmpU(y,201)]);
        %disp(tmpU(y,11));
        tmpU(y,201)=0;
    end
    
tmpU=u;    
    disp('t= 1000 : ');
    %disp();
    for i=1:20
        [x,y]=max(tmpU(:,1001));
        disp([legend(y),'\t\t',tmpU(y,1001)]);
        %disp(tmpU(y,11));
        tmpU(y,1001)=0;
    end
  
    

% disp=[11,101,201,1001];
% for result=1:4
%     disp(['t=',disp(result)-1,' : ']);
%     %disp();
%     for i=1:20
%         [x,y]=max(tmpU(:,disp(result,1)));
%         disp(legend(x));
%         disp(tmpU(x,disp(result,1)));
%         tmpU(x,disp(result,1))=0;
%     end
% end
    
[V,D]=eig(transpose(M));
findIndex=0;
for i=1:teams
    if D(i,i)==1
        findIndex=i;
    end
end
findIndex
D(findIndex,:)
u1=V(:,findIndex);

u1Sum=0;
for i=1:teams
    u1Sum=u1Sum+u1(i,1);
end
wInfinity=u1/u1Sum;

graph=zeros(teams,2);

for t=1:1000
    graph(t,1)=t;
    y=0;
    for i=1:teams
        y=y+(u(i,t+1)-wInfinity(i,1))*(u(i,t+1)-wInfinity(i,1));
    end
    graph(t,2)=sqrt(y);
end
%graph
plot(graph(:,2));

disp('When t=1000, the result is : ');
disp(graph(1000,2));

%find
[x,y]=max(wInfinity(:));
disp('The only winner is : ');
disp(legend(y));




        



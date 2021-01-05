%We read the data from the inputs we have selected from the C.S.V. file.
[coordinates] = xlsread('load_data.csv');
%Then we plot the cities
plot(coordinates(:,1),coordinates(:,2));
%find out the rowsize and the column size
[rowsize, colsize] = size(coordinates);
citySize = rowsize;
last = citySize+1;
ic = zeros(last,2);
for i=1:citySize
 %v = r1(i,1);
 ic(i,1) = coordinates(i,1);
 ic(i,2) = coordinates(i,2);
end
%now add the starting city coordinate
ic(last,1) = coordinates(1,1);
ic(last,2) = coordinates(1,2);
%plot the cities
plot(ic(:,1),ic(:,2));
% delcare a matrix for the city distance
data = zeros(rowsize,rowsize);
%now calculate the distance among the cities
for i=1:rowsize
 for j=1:rowsize
 distance = sqrt((coordinates(i,1)-coordinates(j,1))^2+(coordinates(i,2)-coordinates(j,2))^2);
 data(i,j) = distance;
 end
end
N = 50;
m = rowsize; %number of city 
kmax = 100;
y = 50; %arbitrary value of y
r1 = rand(m,N);

for i=1:N
 r1(:,i)= randperm(m,m);
end
for test_no = 1:kmax
 f = zeros(1,N);
 %Now calculating the path cost
 for a=1:N
 pcost =0;
 j=2;
 loopval = m-1;
 for i=1:loopval
 row = r1(i,a);
 col = r1(j,a);
 pcost = pcost+data(row,col);
 j=j+1;
 end
 first = r1(1,a);
 last = r1(14,a);
 pcostfst_last = data(first,last);
 totalPcost = pcost + pcostfst_last;
 %fprintf('Total path cost of this solution: %f\n', totalPcost);
 f(1,a) = totalPcost; %Adding the path cost of 1st and last
 end
 %sort the cost
 f_sorted = sort(f,'ascend');
 %then sort the solution with respect to the sorted value
 for j=1:N
 r1(:,j) = r1(:,find(f==f_sorted(j),1));
 end
 %Now generate short runners for 10% TOP best solution 
 shortVal = N/10;

 for i=1:shortVal
 %take an arbitray number of y
 %y = randperm(m,1);
 short = ceil(y/i);
 srunner = rand(m,short); %short runners
 for j=1:short
 rdnNo = randi(m,2);
 %swap the random indexed city to generate new solution from short
 %runners to exploit
 tmp = r1(:,i); %temporarily keep the column of r1
 swapPos1 = rdnNo(1,1);
 swapPos2 = rdnNo(2,2);
 swap = tmp (swapPos1);
 tmp (swapPos1) = tmp (swapPos2);
 tmp (swapPos2) = swap;
 srunner(:,j)= tmp; %generate short number of short runner
 %calculate the path cost
 q=2;
 tmppcost=0;
 for p=1:loopval
 row = srunner(p,j);
 col = srunner(q,j);
 tmppcost = tmppcost+data(row,col);
 q=q+1;
 end
 first = srunner(1,j);
 last = srunner(14,j);
 pcostfst_last = data(first,last);
 tmppcost = tmppcost + pcostfst_last;
 %fprintf('Total path cost of this short runner: %f\n', tmppcost);
 if f_sorted(i)>tmppcost 
 r1(:,i) = srunner(:,j);
 else
 %Ignore srunner
 end
 end
 end
 %Now work for long runner
 for i=shortVal+1:N
 %lrunner = rand(m,1);
 randomlong = randperm(m,3); %generate the value of k to apply k-opt rule k>2
 lrunner = r1(:,i); %temporarily keep the column of r1
 swap = lrunner(randomlong(1));
 lrunner(randomlong(1)) = lrunner(randomlong(2));
 lrunner(randomlong(2)) = lrunner(randomlong(3));
 lrunner(randomlong(3)) = swap;
 %calculate the path cost
 q=2;
 tmppcost=0;
 for p=1:loopval
 row = lrunner(p,1);
 col = lrunner(q,1);
 tmppcost = tmppcost+data(row,col);
 q=q+1;
 end
 first = lrunner(1,1);
 last = lrunner(14,1);
 pcostfst_last = data(first,last);
 tmppcost = tmppcost + pcostfst_last;
 if f_sorted(i)>tmppcost
 r1(:,i) = lrunner;
 else
 %Ignore srunner
 end 
 end
fc = zeros(last,2);
for i=1:rowsize
 v = r1(i,1);
 fc(i,1) = coordinates(v,1);
 fc(i,2) = coordinates(v,2);
end
%now add the starting city coordinate
v = r1(1,1);
fc(15,1) = coordinates(v,1);
fc(15,2) = coordinates(v,2);

plot(fc(:,1),fc(:,2));
fprintf('\n so far obtained best solution is %f\n', f_sorted(1,1));
soln = r1(:,1);
soln = soln.';
display(soln);
end
soln = r1(:,1);
soln = soln.';
display(soln);
display(f_sorted(1,1));
plot(fc(:,1),fc(:,2));
function [image_out]=test_dc(IM,lamda,delta,to)
%Step1: Input Y, G
tStart=tic;% timing runing code

filename=IM;
% img_orig=imread('Hoang thi lien 1984 tieu xuong r16,17,27 anh48.jpg');
img_orig=imread(filename);
img1_gray=rgb2gray(img_orig);
img_dou=im2double(img1_gray);
img=imresize(img_dou,0.1);

fname = sprintf('C:\\TEST_150517\\DC\\%s',filename);
mkdir(fname);
filetext = sprintf('%s\\DC.txt',fname);
filetext2 = sprintf('%s\\index_result',fname);
fileID = fopen(filetext,'w');

Y=creatmatrixtif(img);
row=size(Y,1);
col=size(Y,2);

% Step 2: Construct the neutrosophic similarity matrix R
% inner product:
inner_pro=zeros(row,col,3);
for i=1:(row-1)
    for j=2:col
        inner_pro(i,j,1)=max(min(Y(i,:,1),Y(j,:,1)));
        inner_pro(i,j,2)=min(max(Y(i,:,2),Y(j,:,2)));
        inner_pro(i,j,3)=min(max(Y(i,:,3),Y(j,:,3)));
        inner_pro(j,i,1)=max(min(Y(i,:,1),Y(j,:,1)));
        inner_pro(j,i,2)=min(max(Y(i,:,2),Y(j,:,2)));
        inner_pro(j,i,3)=min(max(Y(i,:,3),Y(j,:,3)));
    end
end

%outer product:
outer_pro=zeros(row,col,3);
for i=1:(row-1)
    for j=2:col
        outer_pro(i,j,1)=max(min(Y(i,:,3),Y(j,:,3)));
        outer_pro(i,j,2)=min(max(Y(i,:,2),Y(j,:,2)));
        outer_pro(i,j,3)=min(max(Y(i,:,1),Y(j,:,1)));
        outer_pro(j,i,1)=max(min(Y(i,:,3),Y(j,:,3)));
        outer_pro(j,i,2)=min(max(Y(i,:,2),Y(j,:,2)));
        outer_pro(j,i,3)=min(max(Y(i,:,1),Y(j,:,1)));
    end
end

%similarity matrix
similarity_matrix=zeros(row,col,3);
for i=1:row
    for j=1:col
        if i==j
            similarity_matrix(i,j,1)=1;
            similarity_matrix(i,j,2)=0;
            similarity_matrix(i,j,3)=0;
        else
            similarity_matrix(i,j,1)=min(inner_pro(i,j,1),outer_pro(i,j,1));
            similarity_matrix(i,j,2)=max(inner_pro(i,j,2),outer_pro(i,j,2));
            similarity_matrix(i,j,3)=max(inner_pro(i,j,3),outer_pro(i,j,3));
        end
    end
end

%Step 3: Determine the cutting matrix
%confidence level
% lamda=0.96; delta=0.24; to=0.44;
cutting_matrix=zeros(row,col,3);
for i=1:row
    for j=1:col
        if similarity_matrix(i,j,1)>=lamda && similarity_matrix(i,j,2)<=delta && similarity_matrix(i,j,3)<=to
            cutting_matrix(i,j,1)=1;
            cutting_matrix(i,j,2)=0;
            cutting_matrix(i,j,3)=0;
        end
        if similarity_matrix(i,j,1)<lamda && similarity_matrix(i,j,2)>delta && similarity_matrix(i,j,3)<to
            cutting_matrix(i,j,1)=0;
            cutting_matrix(i,j,2)=1;
            cutting_matrix(i,j,3)=0;
        end
        if similarity_matrix(i,j,1)<lamda && similarity_matrix(i,j,2)<delta && similarity_matrix(i,j,3)>to
            cutting_matrix(i,j,1)=0;
            cutting_matrix(i,j,2)=0;
            cutting_matrix(i,j,3)=1;
        end
    end
end

%Step 4: Calculate the inner products of the column vectors of the cutting matrix
k=1;
for i=1:row
    for j=1:col
        if i~=j
            X=cutting_matrix(:,i,:);
            Z=cutting_matrix(:,j,:);
            I(:,:,1)=max(min(X(:,:,1),Z(:,:,1)));
            I(:,:,2)=min(max(X(:,:,2),Z(:,:,2)));
            I(:,:,3)=min(max(X(:,:,3),Z(:,:,3)));
            if (I(:,:,1)==1 && I(:,:,2)==1) || (I(:,:,1)==1 && I(:,:,2)==0)
                R(1,k,1)=i;
                R(1,k,2)=j;
                k=k+1;
            end
        end
    end
end

size_R=size(R,2);
k=1;
for i=1:size_R
    for j=i+1:size_R
        if R(1,i,1)==R(1,j,2) && R(1,i,2)==R(1,j,1)
            R1(1,k,1)=R(1,i,1);
            R1(1,k,2)=R(1,i,2);
            k=k+1;
        end
    end
end
size_R1=size(R1,2);
id_array=randi([1 151],1,151);
id_array(1,1)=1;
for i=1:size_R1
    for j=1:size_R1
        if R1(1,i,1)==R1(1,j,1)
            id_array(R1(1,j,2))=id_array(R1(1,i,1));
        end
        if R1(1,i,1)==R1(1,j,2)
            id_array(R1(1,j,1))=id_array(R1(1,i,1));
        end
    end
end
id_array=id_array';

Data_normal = mypca(img,3);
cut=1;

clust=id_array;
%Number of clusters
num_clust = numel(unique(clust));

%center id
center_id = findcentroid(clust,Data_normal);

% figure,scatter3(center_id(:,1),center_id(:,2),center_id(:,3),num_clust,clust,'filled');

% figure
% plot3(Data_normal(:,1),Data_normal(:,2),Data_normal(:,3),'.b','linewidt',2);
% set(gca,'nextplot','add');
% plot3(center_id(:,1),center_id(:,2),center_id(:,3),'xr','linewidt',3);
% h = legend('Data to clusterize','Centroids');
% set(h,'fontsize',16,'fontweight','bold');
% title('Clustering Algorithm based Neutrosophic Orthogonal Matrices');
print(filetext2,'-djpeg');

img_re=imresize(img_orig,0.1);
image_out=img_re;
row=size(image_out,1);
col=size(image_out,2);
color = [0 0 0;  255 255 255;  0 0 255;  0 255 0; 236 135 14;
    152	208	185;  255 0 0;
    255 255 0; 255 0 255; 245 168 154; 148	83	5;
    156	153	0; 54 117 23;  0	98	65; 175	215	136
    16	54	103; 81	31	144; 160 149 196; 197 124 172; 215	215	215];

for i=1:row
    for j=1:col
        for k=1:256
            if image_out(i,j)==k-1
                for l=1:num_clust
                    if l>size(center_id,2)
                        break;
                    else
                        if k>size(center_id,1)
                            break;
                        else
                            res=max(center_id(k,:));
                            if center_id(k,l)==res
                                image_out(i,j,:)=color(l,:);
                            end
                        end
                    end
                end
                
            end
        end
    end
end
% figure,imshow(image_out);

% find best DB index
db = DB(Data_normal, center_id, clust);
if (num_clust~=1) && (isnan(db)==0) && (db~=1)
    if (cut ==1)
        max_index(1,1) = cut;
        max_index(1,2) = db;
    else if (db < max_index(1,2))
            max_index(1,1) = cut;
            max_index(1,2) = db;
        end
    end
end

% find best SWC index
swc = SWC(Data_normal, center_id, clust);
if (num_clust~=1) && (isnan(swc)==0) && (swc~=1)
    if (cut ==1)
        max_index(2,1) = cut;
        max_index(2,2) = swc;
    else if (swc > max_index(2,2))
            max_index(2,1) = cut;
            max_index(2,2) = swc;
        end
    end
end

% find best IFV index
ifv = IFV(Data_normal, center_id, clust);
if (num_clust~=1) && (isnan(ifv)==0) && (ifv~=1)
    if (cut ==1)
        max_index(2,1) = cut;
        max_index(3,2) = ifv;
    else if (ifv > max_index(3,2)|| isnan(ifv))
            max_index(2,1) = cut;
            max_index(3,2) = ifv;
        end
    end
end

% find best PBM index
pbm = PBM(Data_normal, center_id, clust);
if (num_clust~=1) && (isnan(pbm)==0) && (pbm~=1)
    if (cut ==1)
        max_index(2,1) = cut;
        max_index(4,2) = pbm;
    else if (pbm > max_index(4,2))
            max_index(2,1) = cut;
            max_index(4,2) = pbm;
        end
    end
end
cut=cut-0.0005;
cnr =Compute_VM(img,5,5);

% end
% fprintf('Best DB ECA: %f in Lambda = %f \n',max_index(1,2),max_index(1,1));
% fprintf('Best SWC ECA: %f in Lambda = %f \n',max_index(2,2),max_index(2,1));
% fprintf('Best IFV ECA: %f in Lambda = %f \n',max_index(3,2),max_index(3,1));
% fprintf('Best PBM ECA: %f in Lambda = %f \n',max_index(4,2),max_index(4,1));
% 
% tElapsed=toc(tStart);
% fprintf('time runing: %f\n',tElapsed);

fprintf(fileID,'%f\n',db);
fprintf(fileID,'%f\n',swc);
fprintf(fileID,'%f\n',ifv);
fprintf(fileID,'%f\n',pbm);
fprintf(fileID,'%f\n',cnr);

filetext1 = sprintf('%s\\img_result.jpg',fname);
imwrite(image_out,filetext1);
tElapsed=toc(tStart);
fprintf(fileID,'%f',tElapsed);
end
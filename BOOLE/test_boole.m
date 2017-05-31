function [image_out]=test_boole(IM,beta)
%load data
tStart=tic;% timing runing code
% filename=('img_13.jpg');
% img_origS=imread('Hoang thi lien 1984 tieu xuong r16,17,27 anh48.jpg');
filename=IM;
img_origS=imread(filename);
img1_grayS=rgb2gray(img_origS);
img_douS=im2double(img1_grayS);
imgS=imresize(img_douS,0.1);

img_origD=imread('img_11.jpg');
img1_grayD=rgb2gray(img_origD);
img_douD=im2double(img1_grayD);
imgD=imresize(img_douD,0.1);

fname = sprintf('C:\\TEST_150517\\BOOLE\\%s',filename);
mkdir(fname);
filetext = sprintf('%s\\BOOLE.txt',fname);
filetext2 = sprintf('%s\\index_result',fname);
fileID = fopen(filetext,'w');

%create matrix T,I,F
tifS=creatmatrixtif(imgS);
tifD=creatmatrixtif(imgD);
d_T_component=tifD(:,:,1);
d_I_component=tifD(:,:,2);
d_F_component=tifD(:,:,3);
s_T_component=tifS(:,:,1);
s_I_component=tifS(:,:,2);
s_F_component=tifS(:,:,3);
%Create similarity matrix D
similarity_matrix = compute_similarity(d_T_component,d_I_component,d_F_component,s_T_component,s_I_component,s_F_component);
d=similarity_matrix;
%beta is the confidence level
% beta=0.5;
%cutting matrix
d_num = size(d_T_component,1);
s_num = size(s_T_component,1);
for i=1:s_num
    for j=1:d_num
        if d(i,j)<=beta
            cutting_matrix(i,j)=0;
        else
            cutting_matrix(i,j)=1;
        end
    end
end

%Check: D is an equivalent association matrix
id_array=randi([1 151],1,151);
result=check_equivalent(d, cutting_matrix);
d_sao=transitive_matrix(cutting_matrix);
if result == 1
    row_bd=size(cutting_matrix,1); col_bd=size(cutting_matrix,2);
    count=0;
    for i=1:col_bd
        for j=1:col_bd
            if i~=j
                if cutting_matrix(:,i)==cutting_matrix(:,j)
                    id_array(i)=id_array(j);
                end
            end
        end
    end
end

id_array=id_array';
clust=id_array;
%Number of clusters
num_clust = numel(unique(clust));
Data_normal = mypca(imgS,3);
cut=1;
%center id
center_id = findcentroid(clust,Data_normal);

for i=size(center_id,1):size(clust,1)
    center_id(i,1)=0;
    center_id(i,2)=0;
    center_id(i,3)=0;
end

% figure,scatter3(center_id(:,1),center_id(:,2),center_id(:,3),num_clust,clust,'filled');

% figure
% plot3(Data_normal(:,1),Data_normal(:,2),Data_normal(:,3),'.b','linewidt',2);
% set(gca,'nextplot','add');
% plot3(center_id(:,1),center_id(:,2),center_id(:,3),'xr','linewidt',3);
% h = legend('Data to clusterize','Centroids');
% set(h,'fontsize',16,'fontweight','bold');
% title('Neutrosophic Clustering Algorithm based on Association Measures and Boole Matrices')
print(filetext2,'-djpeg');

img_re=imresize(img_origS,0.1);
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
                    if l>size(clust,2)
                        break;
                    else
                        if k>size(clust,1)
                            break;
                        else
                            res=max(clust(k,:));
                            if clust(k,l)==res
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

% find VM index
cnr =Compute_VM(imgS,5,5);

% fprintf('Best DB ECA: %f in Lambda = %f \n',max_index(1,2),max_index(1,1));
% fprintf('Best SWC ECA: %f in Lambda = %f \n',max_index(2,2),max_index(2,1));
% fprintf('Best IFV ECA: %f in Lambda = %f \n',max_index(3,2),max_index(3,1));
% fprintf('Best PBM ECA: %f in Lambda = %f \n',max_index(4,2),max_index(4,1));
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
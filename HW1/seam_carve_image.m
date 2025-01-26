%% TODO: implement function: searm_carve_image
% check the title above the image for how to use the user-interface to resize the input image
function im = seam_carve_image(im, sz)

% im = imresize(im, sz);

costfunction = @(im) sum( imfilter(im, [.5 1 .5; 1 -6 1; .5 1 .5]).^2, 3 );

Tim=im;
k = size(im,2) - sz(2);
for i = 1:k
    G = costfunction(Tim);
    %% find a seam in G
    seam=find_seam(G);
    %% remove seam from im
    im=remove_seam(im,seam);
end
end

%%找接缝
function seam=find_seam(G)
[row,col]=size(G);
M=zeros(row,col);
seam=zeros(row,1);
for i=1:row
    for j=1:col
        if(i==1)
            M(1,j)=G(1,j);
        else
            if(j==1)
            M(i,j)=G(i,j)+min(M(i-1,j),M(i-1,j+1));
            elseif(j==col)
                M(i,j)=G(i,j)+min(M(i-1,j-1),M(i-1,j));
            else
                M(i,j)=G(i,j)+min([M(i-1,j-1),M(i-1,j),M(i-1,j+1)]);
            end
        end  
    end
end
    [~, seam(row)] = min(M(row, :));
    for i = row-1:-1:1
        prev_col = seam(i+1);
        if prev_col == 1
            [~, idx] = min([M(i, prev_col), M(i, prev_col+1)]);
           seam(i) = prev_col + (idx - 1);
        elseif prev_col == cols
          [~, idx] = min([M(i, prev_col-1), M(i, prev_col)]);
         seam(i) = prev_col + (idx - 2);
        else
       [~, idx] = min([M(i, prev_col-1), M(i, prev_col), M(i, prev_col+1)]);
       seam(i) = prev_col + (idx - 2);
        end
    end
end

%%去接缝
function im = remove_seam(im, seam)
      [rows, cols, channels] = size(im); 
    new_im = zeros(rows, cols-1, channels, 'uint8');
    for i = 1:rows
        col = seam(i);  
        for c = 1:channels
            new_im(i, :, c) = [im(i, 1:col-1, c), im(i, col+1:end, c)];
        end
    end
    im = new_im;
end


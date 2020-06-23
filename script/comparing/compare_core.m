%-------------------------------------------------------------------------------
  %
  %  Filename      : compare_core
  %  Author        : Huang Leilei
  %  Created       : 2020-06-22
  %  Description   : compare with matlab
  %
%-------------------------------------------------------------------------------

function compare_core(A_FILE, B_FILE, SIZE_FRA_X, SIZE_FRA_Y, NUMB_FRA, DATA_THR_DIF, INDX_SHOW)

%% init
% make directory
if ~exist('dump', 'dir')
    mkdir dump
end
% open files
fptA = fopen(A_FILE, 'r');
fptB = fopen(B_FILE, 'r');
% open figure
figure(1);
set(gcf, 'position', [100, 400, 1100, 600]);


%% main loop
for idxFra = 1:NUMB_FRA
    % read A
    A_y4 = fread(fptA, SIZE_FRA_X     * SIZE_FRA_Y    , 'uint8');
    A_u2 = fread(fptA, SIZE_FRA_X / 2 * SIZE_FRA_Y / 2, 'uint8');
    A_v2 = fread(fptA, SIZE_FRA_X / 2 * SIZE_FRA_Y / 2, 'uint8');
    if isempty(A_v2)
        break;
    end
    % reformat
    A_y4 = reshape(A_y4, SIZE_FRA_X    , SIZE_FRA_Y    );
    A_u2 = reshape(A_u2, SIZE_FRA_X / 2, SIZE_FRA_Y / 2);
    A_v2 = reshape(A_v2, SIZE_FRA_X / 2, SIZE_FRA_Y / 2);
    A_yuv = zeros(SIZE_FRA_Y, SIZE_FRA_X, 3);
    A_yuv(:      , :      , 1) = A_y4';
    A_yuv(1:2:end, 1:2:end, 2) = A_u2';
    A_yuv(1:2:end, 2:2:end, 2) = A_u2';
    A_yuv(2:2:end, 1:2:end, 2) = A_u2';
    A_yuv(2:2:end, 2:2:end, 2) = A_u2';
    A_yuv(1:2:end, 1:2:end, 3) = A_v2';
    A_yuv(1:2:end, 2:2:end, 3) = A_v2';
    A_yuv(2:2:end, 1:2:end, 3) = A_v2';
    A_yuv(2:2:end, 2:2:end, 3) = A_v2';
    % display
    %A_yuv = uint8(A_yuv);
    %A_rgb = ycbcr2rgb(A_yuv);
    %imshow(A_rgb);

    % read B
    B_y4 = fread(fptB, SIZE_FRA_X     * SIZE_FRA_Y    , 'uint8');
    B_u2 = fread(fptB, SIZE_FRA_X / 2 * SIZE_FRA_Y / 2, 'uint8');
    B_v2 = fread(fptB, SIZE_FRA_X / 2 * SIZE_FRA_Y / 2, 'uint8');
    if isempty(B_v2)
        break;
    end
    % reformat
    B_y4 = reshape(B_y4, SIZE_FRA_X    , SIZE_FRA_Y    );
    B_u2 = reshape(B_u2, SIZE_FRA_X / 2, SIZE_FRA_Y / 2);
    B_v2 = reshape(B_v2, SIZE_FRA_X / 2, SIZE_FRA_Y / 2);
    B_yuv = zeros(SIZE_FRA_Y, SIZE_FRA_X, 3);
    B_yuv(:      , :      , 1) = B_y4';
    B_yuv(1:2:end, 1:2:end, 2) = B_u2';
    B_yuv(1:2:end, 2:2:end, 2) = B_u2';
    B_yuv(2:2:end, 1:2:end, 2) = B_u2';
    B_yuv(2:2:end, 2:2:end, 2) = B_u2';
    B_yuv(1:2:end, 1:2:end, 3) = B_v2';
    B_yuv(1:2:end, 2:2:end, 3) = B_v2';
    B_yuv(2:2:end, 1:2:end, 3) = B_v2';
    B_yuv(2:2:end, 2:2:end, 3) = B_v2';
    % display
    %B_yuv = uint8(B_yuv);
    %B_rgb = ycbcr2rgb(B_yuv);
    %imshow(B_rgb);

    % show diff
    flgErr = 0;
    for idxChn = 1:3
        subplot(2, 2, idxChn);
        D_yuv = abs(A_yuv(:, :, idxChn) - B_yuv(:, :, idxChn));
        %D_yuv(D_yuv >  DATA_THR_DIF) = 255;
        %D_yuv(D_yuv <= DATA_THR_DIF) = 0;
        %imshow(D_yuv)
        D_yuv(D_yuv > DATA_THR_DIF) = DATA_THR_DIF;
        mesh(D_yuv);
        view([0,0,1]);
        axis equal;
        axis([1, SIZE_FRA_X, 1, SIZE_FRA_Y]);
        switch idxChn
            case 1
                title('diff in y channel');
            case 2
                title('diff in u channel');
            case 3
                title('diff in v channel');
        end
        if sum(sum(D_yuv)) > 0
            flgErr = 1;
        end
    end

    % show yuv
    subplot(2, 2, 4);
    if INDX_SHOW == 'A'
        S_yuv = uint8(A_yuv);
    else
        S_yuv = uint8(B_yuv);
    end
    S_rgb = ycbcr2rgb(S_yuv);
    imshow(S_rgb);
    title(['frame ', num2str(idxFra), '/', num2str(NUMB_FRA)]);
    drawnow;

    % stop
    if flgErr
        input('press enter to continue', 's');
    end

    % save figure
    fig = getframe(gcf);
    img = frame2im(fig);
    imwrite(img, ['dump/showDiff_frame', num2str(idxFra, '%02d'), '.png']);
end


%% close files
fclose(fptB);
fclose(fptA);

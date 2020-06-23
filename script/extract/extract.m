%------------------------------------------------------------------------------
  %
  %  Filename      : extract
  %  Author        : Huang Leilei
  %  Created       : 2020-06-22
  %  Description   : extract with matlab
  %
%-------------------------------------------------------------------------------

%***PARAMETER *****************************************************************
NAME_SES_A   = 'recode/dump_paper_with_lcu_01_embedded';
NAME_SES_B   = {'embed_paper/dump_with_lcu_01_embedded',    ...
                'embed_paper/dump_with_lcu_02_embedded',    ...
                'embed_paper/dump_with_lcu_03_embedded',    ...
                'embed_paper/dump_with_lcu_04_embedded',    ...
                'embed_paper/dump_with_lcu_08_embedded',    ...
                'embed_paper/dump_with_lcu_09_embedded',    ...
                'embed_paper/dump_with_lcu_10_embedded',    ...
                'embed_paper/dump_with_lcu_15_embedded',    ...
                'embed_paper/dump_with_lcu_16_embedded',    ...
                'embed_paper/dump_with_lcu_22_embedded'
};
NAME_SEQ     = 'BlowingBubbles';
DATA_Q_P     = '22';
SIZE_FRA_X   = 416;
SIZE_FRA_Y   = 240;
NUMB_FRA     = 20;
DATA_THR_DIF = 20;
FLAG_PLT     = 0;
INDX_PLT     = "A";
FLAG_STP     = 0;
NUMB_SES_B   = numel(NAME_SES_B);


%***MAIN BODY *****************************************************************
% main loop
datPsnr = zeros(NUMB_SES_B, 1);
for idx = 1:NUMB_SES_B
  name_Ses_B = NAME_SES_B{idx};
  datTmp = extract_core(['../', NAME_SES_A, '/', NAME_SEQ, '_', DATA_Q_P, '/', 'x265.yuv']    ...
               ,        ['../', name_Ses_B, '/', NAME_SEQ, '_', DATA_Q_P, '/', 'x265.yuv']    ...
               ,        SIZE_FRA_X                                                            ...
               ,        SIZE_FRA_Y                                                            ...
               ,        NUMB_FRA                                                              ...
               ,        DATA_THR_DIF                                                          ...
               ,        FLAG_PLT                                                              ...
               ,        INDX_PLT                                                              ...
               ,        FLAG_STP                                                              ...
  );
  datPsnr(idx) = median(datTmp(:,1));
end

% plot
figure(2);
hold on;
plot(datPsnr);
plot(datPsnr, 'ko');

% tune
set(gcf, 'position', [500, 500, 560, 420]);
title('watermarking extraction');
axis([0, NUMB_SES_B+1, min(datPsnr) - 5, max(datPsnr) + 5]);
grid on;
xlabel('sequence index');
ylabel('psnr');

% save
fig = getframe(gcf);
img = frame2im(fig);
imwrite(img, ['dump/psnr.png']);

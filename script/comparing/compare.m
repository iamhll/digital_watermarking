%------------------------------------------------------------------------------
  %
  %  Filename      : compare
  %  Author        : Huang Leilei
  %  Created       : 2020-06-22
  %  Description   : compare with matlab
  %
%-------------------------------------------------------------------------------

%***PARAMETER *****************************************************************
NAME_SES_A   = 'reference';
NAME_SES_B   = 'embedding_paper';
NAME_SEQ     = 'BlowingBubbles';
DATA_Q_P     = '22';
SIZE_FRA_X   = 416;
SIZE_FRA_Y   = 240;
NUMB_FRA     = inf;
DATA_THR_DIF = 20;
INDX_SHOW    = "A";


%***MAIN BODY *****************************************************************
compare_core(['../', NAME_SES_A, '/dump/', NAME_SEQ, '_', DATA_Q_P, '/', 'x265.yuv']    ...
    ,        ['../', NAME_SES_B, '/dump/', NAME_SEQ, '_', DATA_Q_P, '/', 'x265.yuv']    ...
    ,        SIZE_FRA_X                                                                 ...
    ,        SIZE_FRA_Y                                                                 ...
    ,        NUMB_FRA                                                                   ...
    ,        DATA_THR_DIF                                                               ...
    ,        INDX_SHOW                                                                  ...
);

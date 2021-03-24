function [eig, vec] = jacobi_eigen_vv(matrix)

pMatrix = matrix;

for i = 1:3
    vec(i,i) = 1.0;
    for j = 1:3
        if i ~= j
            vec(i,j) = 0.0;
        end
    end
end

nCount = 0;

while (1)
    
    dbMax = pMatrix(1,2);
    nRow = 1;
    nCol = 2;
    for i = 1:3
        for j = 1:3
            d = abs(pMatrix(i,j));
            if i~=j && d>dbMax
                dbMax = d;
                nRow = i;
                nCol = j;
            end
        end
    end
    
    if dbMax < 1e-15
        break;
    end
    
    if (nCount > 100)
        break;
    end
    
    nCount=nCount+1;
    
    dbApp = pMatrix(nRow,nRow);
    dbApq = pMatrix(nRow,nCol);
    dbAqq = pMatrix(nCol,nCol);
    
    dbAngle = 0.5*atan2(-2 * dbApq, dbAqq - dbApp);
    dbSinTheta = sin(dbAngle);
    dbCosTheta = cos(dbAngle);
    dbSin2Theta = sin(2 * dbAngle);
    dbCos2Theta = cos(2 * dbAngle);
    
    pMatrix(nRow,nRow) = dbApp*dbCosTheta*dbCosTheta + dbAqq*dbSinTheta*dbSinTheta + 2 * dbApq*dbCosTheta*dbSinTheta;
    pMatrix(nCol,nCol) = dbApp*dbSinTheta*dbSinTheta + dbAqq*dbCosTheta*dbCosTheta - 2 * dbApq*dbCosTheta*dbSinTheta;
    pMatrix(nRow,nCol) = 0.5*(dbAqq - dbApp)*dbSin2Theta + dbApq*dbCos2Theta;
    pMatrix(nCol,nRow) = pMatrix(nRow,nCol);
    
    for i=1:3
        if i ~= nCol && i ~= nRow
            dbMax = pMatrix(i,nRow);
            pMatrix(i,nRow) = pMatrix(i,nCol) * dbSinTheta + dbMax*dbCosTheta;
            pMatrix(i,nCol) = pMatrix(i,nCol) * dbCosTheta - dbMax*dbSinTheta;
        end
    end
    
    for j=1:3
        if j ~= nCol && j ~= nRow
            dbMax = pMatrix(nRow,j);
            pMatrix(nRow,j) = pMatrix(nCol,j) * dbSinTheta + dbMax*dbCosTheta;
            pMatrix(nCol,j) = pMatrix(nCol,j) * dbCosTheta - dbMax*dbSinTheta;
        end
    end
    
    
    for i=1:3
        dbMax = vec(i,nRow);
        vec(i,nRow) = vec(i,nCol) * dbSinTheta + dbMax*dbCosTheta;
        vec(i,nCol) = vec(i,nCol) * dbCosTheta - dbMax*dbSinTheta;
    end
end

eig = pMatrix;
end
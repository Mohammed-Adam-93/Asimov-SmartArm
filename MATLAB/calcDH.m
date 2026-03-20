function transform = calcDH(DH)
     
    transform = [cos(DH(1))  -sin(DH(1))*cos(DH(4))  sin(DH(1))*sin(DH(4))   DH(3)*cos(DH(1));
                 sin(DH(1))   cos(DH(1))*cos(DH(4))  -cos(DH(1))*sin(DH(4))  DH(3)*sin(DH(1));
                     0              sin(DH(4))                cos(DH(4))          DH(2)      ;
                     0                  0                        0                  1       ];
end
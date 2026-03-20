function trans = transform(q)
    DH = param(q);
    trans = calcDH(DH(1,:))*calcDH(DH(2,:))*calcDH(DH(3,:))*calcDH(DH(4,:))*calcDH(DH(5,:))*calcDH(DH(6,:));
end
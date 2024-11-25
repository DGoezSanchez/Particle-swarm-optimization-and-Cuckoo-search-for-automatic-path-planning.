function dist=Dis_geodesica(A,B)
    a=90-A(1);
    b=90-B(1);
    Lambda=A(2)-B(2);
    angulo_geo=cosd(a)*cosd(b)+sind(a)*sind(b)*cosd(Lambda);
    Acp=acosd(angulo_geo);
    dist=Acp*40000/360;
end
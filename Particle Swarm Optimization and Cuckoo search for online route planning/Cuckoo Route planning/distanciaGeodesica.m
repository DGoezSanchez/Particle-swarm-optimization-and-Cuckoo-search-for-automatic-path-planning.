function Dt=distanciaGeodesica(Cor1, Cor2)

 degtorad = 0.01745329; 
 radtodeg = 57.29577951; 

 dlong = (Cor1(2) - Cor2(2)); 
%  dvalue = (sin(lat1 * degtorad) * sin(lat2 * degtorad)) + (cos(lat1 * degtorad) * cos(lat2 * degtorad) * cos(dlong * degtorad)); 
    dvalue = (sin(Cor1(1) * degtorad) * sin(Cor2(1) * degtorad)) + (cos(Cor1(1) * degtorad) * cos(Cor2(1) * degtorad) * cos(dlong * degtorad));
 dd = acos(dvalue) * radtodeg; 
  
 miles = (dd * 69.16); 
 km = (dd * 111.302); 
 Dt=km;
end
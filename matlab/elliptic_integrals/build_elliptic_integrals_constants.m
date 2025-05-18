% Store values for calculation with elliptic inctegrals
a.E(1) = 0.44325141463;
a.E(2) = 0.06260601220;
a.E(3) = 0.04757383546;
a.E(4) = 0.01736506451;

b.E(1) = 0.24998368310;
b.E(2) = 0.09200180037;
b.E(3) = 0.04069697526;
b.E(4) = 0.00526449639;

a.K(1) = 1.38629436112;
a.K(2) = 0.09666344259;
a.K(3) = 0.03590092383;
a.K(4) = 0.03742563713;
a.K(5) = 0.01451196212;

b.K(1) = 0.5;
b.K(2) = 0.12498593597;
b.K(3) = 0.06880248576;
b.K(4) = 0.03328355346;
b.K(5) = 0.00441787012;

elliptic_integral_constants = struct('a', a,'b',b);

save("elliptic_integral_constants.mat", "elliptic_integral_constants")
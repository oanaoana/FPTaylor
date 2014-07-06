@rnd = float<ieee_64,ne>;

r1 rnd= 3 + 2 / (r * r) - 0.125 * (3 - 2 * v) * (w * w * r * r) / (1 - v) - 4.5;
r2 rnd= 6*v - 0.5 * v * (w*w*r*r) / (1-v) - 2.5;
r3 rnd= 3 - 2 / (r * r) - 0.125 * (1 + 2 * v) * (w * w * r * r) / (1 - v) - 0.5;

Mr1 = 3 + 2 / (r * r) - 0.125 * (3 - 2 * v) * (w * w * r * r) / (1 - v) - 4.5;
Mr2 = 6*v - 0.5 * v * (w*w*r*r) / (1-v) - 2.5;
Mr3 = 3 - 2 / (r *r) - 0.125 * (1 + 2 * v) * (w * w * r * r) / (1 - v) - 0.5;

{ v in [-4.5, -0.3] /\
  w in [0.4, 0.9] /\
  r in [3.8, 7.8] 
    -> |r1 - Mr1| in ? /\
       |r2 - Mr2| in ? /\
       |r3 - Mr3| in ? }

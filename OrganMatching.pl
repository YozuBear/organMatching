% General Matching for all organs transplant
% Blood matching: http://www.ucdmc.ucdavis.edu/transplant/livingdonation/donor_compatible.html
% If your blood type is: 	You can donate to these blood types:
% 	TYPE O					TYPE O, A, B, AB
% 	TYPE A					TYPE A, AB
% 	TYPE B					TYPE B, AB
% 	TYPE AB					TYPE AB

% All blood types
blood_type(a).
blood_type(b).
blood_type(ab).
blood_type(o).

% blood_type_match(D,R).
% Where D is the blood type of donor, R is blood type of recipient.

% same blood type always match
blood_type_match(A,A):- blood_type(A).

% recipient with blood type AB is universal recipient
blood_type_match(D,ab):- blood_type(D).

% donor with blood type O is universal donor.
blood_type_match(o, R):- blood_type(R).

% TODO: overlapping answers in blood type


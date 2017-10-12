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

% http://www.ucdmc.ucdavis.edu/transplant/learnabout/learn_hla_type_match.html
% https://bethematch.org/patients-and-families/before-transplant/find-a-donor/hla-matching/
% DR antigens: https://en.wikipedia.org/wiki/HLA-DR
% HLA (human leukocyte antigens)Tissue typing: 
% High antigen matching improves the chances for a successful transplant 
% by helping donor cells engraft (make new blood cells) and reduce the risks of immune cells from 
% the donated organ cells (the graft) attack the recipient’s cells.
% A, B, DR antigens are the most relevant for renal transplant
% There are 78 types of DR antigens, will use the common 10 antigens here for simplicity.

% Every person has two A, two B, and two DR antigens inheritted from the parents.
% Each match of antigen with donor (+1 points)


% Recipient and donor in same city (+3 points)


% Kidneys storage must be within 30 hrs, fresher kidney is preferred.


% Assigning kidneys to different patients

% Children under 5 are given priority (+4 points)
% Patients between age of 5~17 given priority (+2 points)


% recipients who were once a donor given priority (+6 points)


% https://en.wikipedia.org/wiki/Panel_reactive_antibody
% Panel reactive antibody (PRA): 
% An immunological test that estimates the percentage of donors with whom a particular recipient would be incompatible.
% A high PRA means that the recipient's immune system is likely going to reject most donor organs.
% The PRA score is between 0% and 99%. 




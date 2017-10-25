% Section A. Compatible blood type

% 1.
% blood_type_match(Donor,Recipient)
blood_type_match(a, X).

% 2.
% Given a recipient ID, return list of compatible kidney IDs based on blood type.
% matching_blood_type_ID(RecipientID, KidneyID)
matching_blood_type_ID(recipient_7, KidneyID).

% Section B. Ranking kidneys for each recipient.
% 3.
% Each match of antigen with donor (+1 point)
hlaMatch_a1(recipient_7, kidney_2, HLA1Point).
hlaMatch_a1(recipient_14, kidney_4, HLA1Point).

% 4. 
% If the recipient and donor are in the same city, +3 points.
same_city_match(recipient_7, kidney_2, CityPoint).
prop(recipient_7, recipient_city, A).
prop(kidney_2, donor_city, B).

% 5.
% Living donor? (+2 points)
living_donor(kidney_2, LivingDonorPoint).

% 6. 
% Kidney Score of kidney_2 for recipient_7
kidney_score(recipient_7, kidney_2, S).

% 7. 
% Calculate the score of compatible kidney to the recipient
% Create a pair of score of kidney as key, and kidney ID as value.
kidney_score(recipient_7, K).

% 8.
% Given a recipient ID, output list of kidneys that are compatible with
% the recipient, in descending order of compatibility.
sort_pairs(recipient_7, Sorted).


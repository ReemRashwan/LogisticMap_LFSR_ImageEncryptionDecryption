%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% THIS PROGRAM IMPLEMENTS THE ALGORITHM PROPOSED IN 
% 'Image Encryption and Decryption using Chaotic Key Sequence Generated
% by Sequence of Logistic Map and Sequence of States of Linear Feedback 
% Shift' research paper.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% KEY GENERATION STEPS:
% 1. Generate a sequence of keys using logistic map equation.
% 2. Generate a sequence of keys using linear feedback shift register.
% 3. XOR the binary version of the previous sequences to form the final key sequence.

% ENCRYPTION STEPS:
% 1. Split colored img channels. 
% 2. Convert each pixel value into block of 8-bits.
% 3. XOR the final key sequence with the binary image pixels.

% DECRYPTION STEPS:
% 1. Split encrypted img channels. 
% 2. Convert each pixel value into block of 8-bits.
% 3. XOR the key sequence (which was used to encrypt the image) with encrypted img pixels.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

img = imread('flowers.jpg');

% figure
% imshow(img)

% constants to construct a logistic sequence
logistic_r = 3.99;
logistic_x = 0.1; 
% we chosed x value between 0 and 1 to generate numbers
% that are between 0 and 1 so we can multiply them by 255
% to convert their values to be between 0 and 255


% seperating channels (3 gray imgs)
[r, g, b] = split_img(img);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENCRYPTION

% STEP ONE: FLATTEN THE PICTURES, CONVERT THEM TO BINARY ARRAYS
% flattening 2d arrays into 1d arrays
r = r(:);
g = g(:);
b = b(:);

% corresponding binary arrays of pixel values
% row vectors
r_binary = cellstr(dec2bin(r, 8));
g_binary = cellstr(dec2bin(g, 8));
b_binary = cellstr(dec2bin(b, 8));


flattened_img_size = size(r,1);

% STEP TWO: 
% 1. generate a sequence of numbers of img size using logistic map
chaotic_seq = zeros(flattened_img_size,1);

% check size of chaotic sequence
size(chaotic_seq);

% initializing the first element in the array with X0 = 0.38
chaotic_seq(1) = logistic_x ;

for i= 2: flattened_img_size
  chaotic_seq(i) = logistic_r * chaotic_seq(i-1) * (1 - chaotic_seq(i-1));
end


% converting vector values which are between 0 and 1 
% to range(0, 255) by multiplying by 255 and rounding the result
% to the nearest integer.

for i= 1: flattened_img_size
  chaotic_seq(i) = round(chaotic_seq(i) * 255);
end

% converting chaotic_seq to 8-bit binary vector.
% we will call this: key sequence
binary_choatic_seq = cellstr(dec2bin(chaotic_seq, 8)); % 8 here means at least 8 bits

% generating a key sequence of N keys using linear feedback shift register 
% with '10111111' as a seed. (N = number of pixels)
lfsr_seq = LFSR('10111111', flattened_img_size);


% initializing final key sequence that is composed of 
% chaotic sequence XORed with lfsr sequence
final_key_seq = zeros(flattened_img_size, 1);
final_key_seq = cellstr(dec2bin(final_key_seq, 8));

% XORing binary choatic seqence with LFSR sequence to form
% *** THE FINAL KEY SEQUENCE *** 
for i = 1 : flattened_img_size
  final_key_seq{i} =  xor(lfsr_seq{i}, binary_choatic_seq{i} - '0');
end


% initializing final binary encrypted channels
r_enc_binary = cellstr(zeros(flattened_img_size, 1));
g_enc_binary = cellstr(zeros(flattened_img_size, 1));
b_enc_binary = cellstr(zeros(flattened_img_size, 1));



% XORing binary pixels with new sequence
for i = 1 : flattened_img_size
  r_enc_binary(i) = xor(r_binary{i} - '0', final_key_seq{i});
  g_enc_binary(i) = xor(g_binary{i} - '0', final_key_seq{i});
  b_enc_binary(i) = xor(b_binary{i} - '0', final_key_seq{i});
end

% initializing final decimal encrypted channels
r_enc_decimal = zeros(flattened_img_size,1);
g_enc_decimal = zeros(flattened_img_size,1);
b_enc_decimal = zeros(flattened_img_size,1);

% converting binary pixels to decimal
for i = 1 : flattened_img_size
  r_enc_decimal(i) = bin2dec(num2str(r_enc_binary{i})); % num2str due to base2dec: S must be a string or cellstring
  g_enc_decimal(i) = bin2dec(num2str(g_enc_binary{i}));
  b_enc_decimal(i) = bin2dec(num2str(b_enc_binary{i}));
end

% reshaping channels to the original img dimensions
r_enc_decimal = reshape(r_enc_decimal, size(img, 1), size(img, 2));
g_enc_decimal = reshape(g_enc_decimal, size(img, 1), size(img, 2));
b_enc_decimal = reshape(b_enc_decimal, size(img, 1), size(img, 2));

% merging final encrypted channels
enc_img = merge_img(uint8(r_enc_decimal), uint8(g_enc_decimal), uint8(b_enc_decimal));

% displaying encrypted img
% enc_img = uint8(enc_img);
figure
imshow(enc_img)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DECRYPTION


[r_dec, g_dec, b_dec] = split_img(enc_img);

% flattening 2d arrays into 1d arrays
r_dec = r_dec(:);
g_dec = g_dec(:);
b_dec = b_dec(:);

% initializing binary decrypted channels
r_dec_binary = cellstr(dec2bin(r_dec, 8))';
g_dec_binary = cellstr(dec2bin(g_dec, 8))';
b_dec_binary = cellstr(dec2bin(b_dec, 8))';

% XORing encrypted img channels with the key that was used to 
% construct the encrypted img.
for i = 1 : flattened_img_size
  r_dec_binary{i} = xor(r_dec_binary{i} - '0', final_key_seq{i});
  g_dec_binary{i} = xor(g_dec_binary{i} - '0', final_key_seq{i});
  b_dec_binary{i} = xor(b_dec_binary{i} - '0', final_key_seq{i});
end

% from binary to decimal
for i = 1 : flattened_img_size
  r_dec(i) = bin2dec(num2str(r_dec_binary{i})); % num2str due to base2dec: S must be a string or cellstring
  g_dec(i) = bin2dec(num2str(g_dec_binary{i}));
  b_dec(i) = bin2dec(num2str(b_dec_binary{i}));
end

% reshaping channels to the original img dimensions
r_dec = reshape(r_dec, size(img, 1), size(img, 2));
g_dec = reshape(g_dec, size(img, 1), size(img, 2));
b_dec = reshape(b_dec, size(img, 1), size(img, 2));

% merging final decrypted channels
dec_img = merge_img(uint8(r_dec), uint8(g_dec), uint8(b_dec));

% displaying decrypted img
% dec_img = uint8(dec_img);
figure
imshow(dec_img)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MEASURING NPCR AND UACII
NPCR = mesure_npcr(dec_img, enc_img);
UACII = mesure_uaci(dec_img, enc_img);


 
% Simscape(TM) Multibody(TM) version: 6.0

% This is a model data file derived from a Simscape Multibody Import XML file using the smimport function.
% The data in this file sets the block parameter values in an imported Simscape Multibody model.
% For more information on this file, see the smimport function help page in the Simscape Multibody documentation.
% You can modify numerical values, but avoid any other changes to this file.
% Do not add code to this file. Do not edit the physical units shown in comments.

%%%VariableName:smiData


%============= RigidTransform =============%

%Initialize the RigidTransform structure array by filling in null values.
smiData.RigidTransform(32).translation = [0.0 0.0 0.0];
smiData.RigidTransform(32).angle = 0.0;
smiData.RigidTransform(32).axis = [0.0 0.0 0.0];
smiData.RigidTransform(32).ID = '';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(1).translation = [0 -20.000000000000018 0];  % mm
smiData.RigidTransform(1).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(1).axis = [-0.57735026918962584 -0.57735026918962584 -0.57735026918962584];
smiData.RigidTransform(1).ID = 'B[hidraulicki_trans2:klip_trans2-1:-:hidraulicki_trans2:cilindar_trans2-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(2).translation = [1889.9999999742024 9.5495579444104806e-08 -9.1098627308383584e-08];  % mm
smiData.RigidTransform(2).angle = 2.0943951023931962;  % rad
smiData.RigidTransform(2).axis = [-0.57735026918962551 -0.57735026918962606 0.57735026918962573];
smiData.RigidTransform(2).ID = 'F[hidraulicki_trans2:klip_trans2-1:-:hidraulicki_trans2:cilindar_trans2-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(3).translation = [-619.99999999999989 0 0];  % mm
smiData.RigidTransform(3).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(3).axis = [0.57735026918962584 0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(3).ID = 'B[hidraulicki_rot:cilindar_rot-2:-:hidraulicki_rot:klip_rot-2]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(4).translation = [9.5769792096689343e-10 1189.9999999990221 -1.8116598499151929e-11];  % mm
smiData.RigidTransform(4).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(4).axis = [0.57735026918962584 -0.57735026918962551 0.57735026918962606];
smiData.RigidTransform(4).ID = 'F[hidraulicki_rot:cilindar_rot-2:-:hidraulicki_rot:klip_rot-2]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(5).translation = [-1930 0 0];  % mm
smiData.RigidTransform(5).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(5).axis = [-0.57735026918962584 -0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(5).ID = 'B[hidraulicki_trans1:cilindar_trans1-1:-:hidraulicki_trans1:klip_trans1-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(6).translation = [-7.6765900303144008e-09 3799.9999999881902 -3.3115449271647799e-09];  % mm
smiData.RigidTransform(6).angle = 2.0943951023931962;  % rad
smiData.RigidTransform(6).axis = [-0.57735026918962595 -0.57735026918962562 -0.57735026918962562];
smiData.RigidTransform(6).ID = 'F[hidraulicki_trans1:cilindar_trans1-1:-:hidraulicki_trans1:klip_trans1-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(7).translation = [-4199.9999999999991 250.00000000000011 114.99999999999977];  % mm
smiData.RigidTransform(7).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(7).axis = [-0.57735026918962584 -0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(7).ID = 'B[treci_clanak-1:-:cetvrti_clanak-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(8).translation = [-115 229.99999999999886 4118.9999999999982];  % mm
smiData.RigidTransform(8).angle = 3.1415926535897927;  % rad
smiData.RigidTransform(8).axis = [2.1597307275911248e-16 1.457167719820518e-16 -1];
smiData.RigidTransform(8).ID = 'F[treci_clanak-1:-:cetvrti_clanak-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(9).translation = [-115.0000000000004 114.99999999999932 4049.9999999999991];  % mm
smiData.RigidTransform(9).angle = 2.0943951023931957;  % rad
smiData.RigidTransform(9).axis = [0.57735026918962584 0.57735026918962573 0.57735026918962573];
smiData.RigidTransform(9).ID = 'B[cetvrti_clanak-1:-:hidraulicki_trans2-2:klip_trans2-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(10).translation = [-114.99999990451124 3834.999999973918 -9.1464698925847188e-08];  % mm
smiData.RigidTransform(10).angle = 2.0943951023931966;  % rad
smiData.RigidTransform(10).axis = [0.57735026918962529 0.57735026918962606 0.57735026918962584];
smiData.RigidTransform(10).ID = 'F[cetvrti_clanak-1:-:hidraulicki_trans2-2:klip_trans2-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(11).translation = [-20.000000000000046 400.0000000000008 1634.294339612155];  % mm
smiData.RigidTransform(11).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(11).axis = [0.57735026918962584 0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(11).ID = 'B[drugi_clanak-1:-:hidraulicki_trans1-1:cilindar_trans1-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(12).translation = [1966.0000000003402 -135.00000000000364 8.0262907431460917e-11];  % mm
smiData.RigidTransform(12).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(12).axis = [0.57735026918962584 -0.57735026918962595 0.57735026918962562];
smiData.RigidTransform(12).ID = 'F[drugi_clanak-1:-:hidraulicki_trans1-1:cilindar_trans1-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(13).translation = [-20.000000000000128 50.00000000000027 1999.9999999999995];  % mm
smiData.RigidTransform(13).angle = 3.1415926535897931;  % rad
smiData.RigidTransform(13).axis = [-1 -0 -0];
smiData.RigidTransform(13).ID = 'B[drugi_clanak-1:-:treci_clanak-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(14).translation = [178.48556695580061 269.99999999999523 -105.00000000000011];  % mm
smiData.RigidTransform(14).angle = 2.0943951023931944;  % rad
smiData.RigidTransform(14).axis = [-0.57735026918962584 -0.57735026918962562 0.57735026918962573];
smiData.RigidTransform(14).ID = 'F[drugi_clanak-1:-:treci_clanak-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(15).translation = [-90.710678118654855 449.99999999999972 -26.485116622529002];  % mm
smiData.RigidTransform(15).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(15).axis = [0.57735026918962584 0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(15).ID = 'B[prvi_clanak-2:-:drugi_clanak-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(16).translation = [-70.710678118655551 49.999999999935199 2000.0000000001553];  % mm
smiData.RigidTransform(16).angle = 2.0943951023931962;  % rad
smiData.RigidTransform(16).axis = [0.57735026918962551 0.57735026918962595 0.57735026918962595];
smiData.RigidTransform(16).ID = 'F[prvi_clanak-2:-:drugi_clanak-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(17).translation = [-154.99999999999997 1235 1.1102230246251565e-13];  % mm
smiData.RigidTransform(17).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(17).axis = [0.57735026918962584 0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(17).ID = 'B[hidraulicki_rot-1:klip_rot-2:-:drugi_clanak-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(18).translation = [9.5781160780461505e-10 -124.99999999909329 1360.0000000003727];  % mm
smiData.RigidTransform(18).angle = 2.094395102393197;  % rad
smiData.RigidTransform(18).axis = [-0.57735026918962562 -0.57735026918962618 0.57735026918962551];
smiData.RigidTransform(18).ID = 'F[hidraulicki_rot-1:klip_rot-2:-:drugi_clanak-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(19).translation = [-199.99999999999994 270 0];  % mm
smiData.RigidTransform(19).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(19).axis = [0.57735026918962584 -0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(19).ID = 'B[treci_clanak-1:-:hidraulicki_trans2-2:cilindar_trans2-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(20).translation = [1966.0000000002876 134.99999999999989 -7.1167960413731635e-11];  % mm
smiData.RigidTransform(20).angle = 2.0943951023931948;  % rad
smiData.RigidTransform(20).axis = [0.57735026918962551 -0.57735026918962595 0.57735026918962573];
smiData.RigidTransform(20).ID = 'F[treci_clanak-1:-:hidraulicki_trans2-2:cilindar_trans2-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(21).translation = [-20.000000000000018 -1250.0000000000005 -666.48511662252929];  % mm
smiData.RigidTransform(21).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(21).axis = [0.57735026918962584 0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(21).ID = 'B[prvi_clanak-2:-:hidraulicki_rot-1:cilindar_rot-2]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(22).translation = [665.9999999999693 154.99999999999966 5.3063331506564282e-11];  % mm
smiData.RigidTransform(22).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(22).axis = [-0.57735026918962584 -0.57735026918962584 -0.57735026918962584];
smiData.RigidTransform(22).ID = 'F[prvi_clanak-2:-:hidraulicki_rot-1:cilindar_rot-2]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(23).translation = [0 -100.00000000000009 0];  % mm
smiData.RigidTransform(23).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(23).axis = [-0.57735026918962584 -0.57735026918962584 -0.57735026918962584];
smiData.RigidTransform(23).ID = 'B[postolje-1:-:prvi_clanak-2]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(24).translation = [-165.00000000000182 -1429.9999999999998 -268.13011306794931];  % mm
smiData.RigidTransform(24).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(24).axis = [-0.57735026918962584 -0.57735026918962584 -0.57735026918962584];
smiData.RigidTransform(24).ID = 'F[postolje-1:-:prvi_clanak-2]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(25).translation = [-1.9428902930940239e-13 49.999999999999822 1999.9999999999995];  % mm
smiData.RigidTransform(25).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(25).axis = [0.57735026918962584 0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(25).ID = 'B[drugi_clanak-1:-:hidraulicki_trans1-1:klip_trans1-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(26).translation = [154.99999999232534 -462.17695033527082 -349.5068970623289];  % mm
smiData.RigidTransform(26).angle = 3.1406398331172309;  % rad
smiData.RigidTransform(26).axis = [0.70710670094167971 0.0004764102723239734 0.70710670094167982];
smiData.RigidTransform(26).ID = 'F[drugi_clanak-1:-:hidraulicki_trans1-1:klip_trans1-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(27).translation = [-4118.2165246077184 249.99999999999946 250.29698821427669];  % mm
smiData.RigidTransform(27).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(27).axis = [-0.57735026918962584 -0.57735026918962584 -0.57735026918962584];
smiData.RigidTransform(27).ID = 'B[treci_clanak-1:-:hidraulicki_trans1-1:klip_trans1-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(28).translation = [114.99999999232659 3834.999999987856 -2.914930519182235e-09];  % mm
smiData.RigidTransform(28).angle = 2.0943951023931957;  % rad
smiData.RigidTransform(28).axis = [0.57735026918962562 0.57735026918962573 0.57735026918962573];
smiData.RigidTransform(28).ID = 'F[treci_clanak-1:-:hidraulicki_trans1-1:klip_trans1-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(29).translation = [1366.9684109390366 2411.912935378808 -4702.4548774814966];  % mm
smiData.RigidTransform(29).angle = 0;  % rad
smiData.RigidTransform(29).axis = [0 0 0];
smiData.RigidTransform(29).ID = 'AssemblyGround[hidraulicki_trans2-2:cilindar_trans2-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(30).translation = [-812.71721077834911 -55.428691010664636 -817.63191589668281];  % mm
smiData.RigidTransform(30).angle = 0;  % rad
smiData.RigidTransform(30).axis = [0 0 0];
smiData.RigidTransform(30).ID = 'AssemblyGround[hidraulicki_rot-1:cilindar_rot-2]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(32).translation = [84.137021109647264 935.20909423020669 -1004.5050670222054];  % mm
smiData.RigidTransform(32).angle = 0;  % rad
smiData.RigidTransform(32).axis = [0 0 0];
smiData.RigidTransform(32).ID = 'AssemblyGround[hidraulicki_trans1-1:cilindar_trans1-1]';


%============= Solid =============%
%Center of Mass (CoM) %Moments of Inertia (MoI) %Product of Inertia (PoI)

%Initialize the Solid structure array by filling in null values.
smiData.Solid(11).mass = 0.0;
smiData.Solid(11).CoM = [0.0 0.0 0.0];
smiData.Solid(11).MoI = [0.0 0.0 0.0];
smiData.Solid(11).PoI = [0.0 0.0 0.0];
smiData.Solid(11).color = [0.0 0.0 0.0];
smiData.Solid(11).opacity = 0.0;
smiData.Solid(11).ID = '';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(1).mass = 611.32550019538769;  % kg
smiData.Solid(1).CoM = [0 114.99999999999997 2329.4257140200739];  % mm
smiData.Solid(1).MoI = [1105312719.6740139 1105321018.9518628 8984388.0816599932];  % kg*mm^2
smiData.Solid(1).PoI = [4.4007558806162035e-09 -1.736855219822824e-08 -9.5239011263146908e-10];  % kg*mm^2
smiData.Solid(1).color = [0.52941176470588236 0.5490196078431373 0.5490196078431373];
smiData.Solid(1).opacity = 1;
smiData.Solid(1).ID = 'cetvrti_clanak*:*Default';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(2).mass = 159.9378349295165;  % kg
smiData.Solid(2).CoM = [48.516538413403573 0 0];  % mm
smiData.Solid(2).MoI = [1007510.4588308459 220299164.12908426 220312595.57493448];  % kg*mm^2
smiData.Solid(2).PoI = [0 -3.6504033193229109e-09 -1.096111959637665e-09];  % kg*mm^2
smiData.Solid(2).color = [0.52941176470588236 0.5490196078431373 0.5490196078431373];
smiData.Solid(2).opacity = 1;
smiData.Solid(2).ID = 'cilindar_trans2*:*Default';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(3).mass = 38.297695662935638;  % kg
smiData.Solid(3).CoM = [2.7031826726926448e-07 1904.2083205254505 6.6189956886152332e-06];  % mm
smiData.Solid(3).MoI = [59958190.695110999 23206.203377558264 59965301.164040737];  % kg*mm^2
smiData.Solid(3).PoI = [-0.36708405063406152 -0.025379134135519531 -0.015844785833427275];  % kg*mm^2
smiData.Solid(3).color = [0.52941176470588236 0.5490196078431373 0.5490196078431373];
smiData.Solid(3).opacity = 1;
smiData.Solid(3).ID = 'klip_trans2*:*Default';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(4).mass = 536.36003217611199;  % kg
smiData.Solid(4).CoM = [-171.83620857252967 -818.06553074266344 -236.88005820093858];  % mm
smiData.Solid(4).MoI = [172301212.63504496 30778106.363621432 169342587.2215842];  % kg*mm^2
smiData.Solid(4).PoI = [-14601571.071492165 53029.195350438153 895029.23388580268];  % kg*mm^2
smiData.Solid(4).color = [0.52941176470588236 0.5490196078431373 0.5490196078431373];
smiData.Solid(4).opacity = 1;
smiData.Solid(4).ID = 'prvi_clanak*:*Default';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(5).mass = 77.42570048128124;  % kg
smiData.Solid(5).CoM = [44.461435154599364 0 0];  % mm
smiData.Solid(5).MoI = [805622.40676944947 13910291.912920358 13944772.657868151];  % kg*mm^2
smiData.Solid(5).PoI = [0 -1.7827656371731095e-09 0];  % kg*mm^2
smiData.Solid(5).color = [0.52941176470588236 0.5490196078431373 0.5490196078431373];
smiData.Solid(5).opacity = 1;
smiData.Solid(5).ID = 'cilindar_rot*:*Default';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(6).mass = 27.87381754644402;  % kg
smiData.Solid(6).CoM = [-4.3531490693328965e-07 597.37564357477504 4.45043368524084e-05];  % mm
smiData.Solid(6).MoI = [5899527.7580450466 68871.649928071478 5933912.4336322453];  % kg*mm^2
smiData.Solid(6).PoI = [-0.57096139813134184 -0.02114877554645218 0.010717403958976728];  % kg*mm^2
smiData.Solid(6).color = [0.52941176470588236 0.5490196078431373 0.5490196078431373];
smiData.Solid(6).opacity = 1;
smiData.Solid(6).ID = 'klip_rot*:*Default';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(7).mass = 3794.4322158934997;  % kg
smiData.Solid(7).CoM = [0 -499.5545200962668 0];  % mm
smiData.Solid(7).MoI = [428600820.34533042 393978968.20493734 428600820.34533054];  % kg*mm^2
smiData.Solid(7).PoI = [1.0111713693481593e-08 3.1329715839863139e-08 -8.7917219931780836e-08];  % kg*mm^2
smiData.Solid(7).color = [0.52941176470588236 0.5490196078431373 0.5490196078431373];
smiData.Solid(7).opacity = 1;
smiData.Solid(7).ID = 'postolje*:*Default';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(8).mass = 807.88202102205742;  % kg
smiData.Solid(8).CoM = [-155 149.89213197364853 188.33834768462708];  % mm
smiData.Solid(8).MoI = [1226888870.3623025 1226486980.7210526 22322388.886821833];  % kg*mm^2
smiData.Solid(8).PoI = [6490925.686808791 1.6121922369537144e-08 -3.5940620161638839e-09];  % kg*mm^2
smiData.Solid(8).color = [0.52941176470588236 0.5490196078431373 0.5490196078431373];
smiData.Solid(8).opacity = 1;
smiData.Solid(8).ID = 'drugi_clanak*:*Default';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(9).mass = 664.18123946232345;  % kg
smiData.Solid(9).CoM = [-2106.4501855376993 135.00000000000017 1.6133857039841293];  % mm
smiData.Solid(9).MoI = [14057241.389759257 1005003110.4612381 1004885235.0618103];  % kg*mm^2
smiData.Solid(9).PoI = [-4.8768266201750912e-09 2147692.6480581262 -3.1561805897524994e-08];  % kg*mm^2
smiData.Solid(9).color = [0.52941176470588236 0.5490196078431373 0.5490196078431373];
smiData.Solid(9).opacity = 1;
smiData.Solid(9).ID = 'treci_clanak*:*Default';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(10).mass = 160.52594107426916;  % kg
smiData.Solid(10).CoM = [55.54147032580201 0 0];  % mm
smiData.Solid(10).MoI = [1016991.2199727022 222454101.27363658 222476469.48244473];  % kg*mm^2
smiData.Solid(10).PoI = [0 -3.6422314053761009e-09 0];  % kg*mm^2
smiData.Solid(10).color = [0.52941176470588236 0.5490196078431373 0.5490196078431373];
smiData.Solid(10).opacity = 1;
smiData.Solid(10).ID = 'cilindar_trans1*:*Default';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(11).mass = 38.885801807687628;  % kg
smiData.Solid(11).CoM = [2.6623000027062271e-07 1933.4094787412632 6.5188904502426405e-06];  % mm
smiData.Solid(11).MoI = [62118010.603583224 29981.676253555383 62131352.547205053];  % kg*mm^2
smiData.Solid(11).PoI = [-0.35968178176884358 -0.02537913413844077 -0.01554247935232644];  % kg*mm^2
smiData.Solid(11).color = [0.52941176470588236 0.5490196078431373 0.5490196078431373];
smiData.Solid(11).opacity = 1;
smiData.Solid(11).ID = 'klip_trans1*:*Default';


%============= Joint =============%
%X Revolute Primitive (Rx) %Y Revolute Primitive (Ry) %Z Revolute Primitive (Rz)
%X Prismatic Primitive (Px) %Y Prismatic Primitive (Py) %Z Prismatic Primitive (Pz) %Spherical Primitive (S)
%Constant Velocity Primitive (CV) %Lead Screw Primitive (LS)
%Position Target (Pos)

%Initialize the CylindricalJoint structure array by filling in null values.
smiData.CylindricalJoint(3).Rz.Pos = 0.0;
smiData.CylindricalJoint(3).Pz.Pos = 0.0;
smiData.CylindricalJoint(3).ID = '';

%This joint has been chosen as a cut joint. Simscape Multibody treats cut joints as algebraic constraints to solve closed kinematic loops. The imported model does not use the state target data for this joint.
smiData.CylindricalJoint(1).Rz.Pos = 90.000000000006409;  % deg
smiData.CylindricalJoint(1).Pz.Pos = 0;  % mm
smiData.CylindricalJoint(1).ID = '[cetvrti_clanak-1:-:hidraulicki_trans2-2:klip_trans2-1]';

%This joint has been chosen as a cut joint. Simscape Multibody treats cut joints as algebraic constraints to solve closed kinematic loops. The imported model does not use the state target data for this joint.
smiData.CylindricalJoint(2).Rz.Pos = 22.724258080923921;  % deg
smiData.CylindricalJoint(2).Pz.Pos = 0;  % mm
smiData.CylindricalJoint(2).ID = '[hidraulicki_rot-1:klip_rot-2:-:drugi_clanak-1]';

%This joint has been chosen as a cut joint. Simscape Multibody treats cut joints as algebraic constraints to solve closed kinematic loops. The imported model does not use the state target data for this joint.
smiData.CylindricalJoint(3).Rz.Pos = -89.922794413476012;  % deg
smiData.CylindricalJoint(3).Pz.Pos = 0;  % mm
smiData.CylindricalJoint(3).ID = '[treci_clanak-1:-:hidraulicki_trans1-1:klip_trans1-1]';


%Initialize the PrismaticJoint structure array by filling in null values.
smiData.PrismaticJoint(2).Pz.Pos = 0.0;
smiData.PrismaticJoint(2).ID = '';

smiData.PrismaticJoint(1).Pz.Pos = 0;  % m
smiData.PrismaticJoint(1).ID = '[treci_clanak-1:-:cetvrti_clanak-1]';

smiData.PrismaticJoint(2).Pz.Pos = 0;  % m
smiData.PrismaticJoint(2).ID = '[drugi_clanak-1:-:treci_clanak-1]';


%Initialize the RevoluteJoint structure array by filling in null values.
smiData.RevoluteJoint(8).Rz.Pos = 0.0;
smiData.RevoluteJoint(8).ID = '';

smiData.RevoluteJoint(1).Rz.Pos = -90;  % deg
smiData.RevoluteJoint(1).ID = '[hidraulicki_trans2-2:klip_trans2-1:-:hidraulicki_trans2-2:cilindar_trans2-1]';

smiData.RevoluteJoint(2).Rz.Pos = -89.999999999999957;  % deg
smiData.RevoluteJoint(2).ID = '[hidraulicki_rot-1:cilindar_rot-2:-:hidraulicki_rot-1:klip_rot-2]';

smiData.RevoluteJoint(3).Rz.Pos = 90.000000000000014;  % deg
smiData.RevoluteJoint(3).ID = '[hidraulicki_trans1-1:cilindar_trans1-1:-:hidraulicki_trans1-1:klip_trans1-1]';

smiData.RevoluteJoint(4).Rz.Pos = -179.92279441347608;  % deg
smiData.RevoluteJoint(4).ID = '[drugi_clanak-1:-:hidraulicki_trans1-1:cilindar_trans1-1]';

smiData.RevoluteJoint(5).Rz.Pos = -18.818524242242315;  % deg
smiData.RevoluteJoint(5).ID = '[prvi_clanak-2:-:drugi_clanak-1]';

smiData.RevoluteJoint(6).Rz.Pos = 6.3801990330957758e-12;  % deg
smiData.RevoluteJoint(6).ID = '[treci_clanak-1:-:hidraulicki_trans2-2:cilindar_trans2-1]';

smiData.RevoluteJoint(7).Rz.Pos = 93.905733838681613;  % deg
smiData.RevoluteJoint(7).ID = '[prvi_clanak-2:-:hidraulicki_rot-1:cilindar_rot-2]';

smiData.RevoluteJoint(8).Rz.Pos = -43.916427658392386;  % deg
smiData.RevoluteJoint(8).ID = '[postolje-1:-:prvi_clanak-2]';


% myChan2 ��λ��������ı仯

% ��վ��Ŀ
BSN = 4;

% ������վ��λ��
BS = [0, sqrt(3), 0.5*sqrt(3), -0.5*sqrt(3), -sqrt(3), -0.5*sqrt(3), 0.5*sqrt(3); 
      0,      0,         1.5,          1.5,        0,         -1.5,        -1.5]; 
BS = BS(:,1:BSN);
BS = BS .* 50;

% ������վ��λ��
plot(BS(1,:), BS(2,:), 'rs', 'markersize',7, 'Markerfacecolor','r');
axis equal;
hold on;

% MS��һϵ��ʵ��λ��
MS = [-50, -100, -150, -200, 50,  100, 200, 0,   0,   0,   0;
      -50, -100, -150, -200, 0,   0,   0,   50,  100, 150, 200 ];
% MS = [0,   0,   0,   0,   0,   0,   0,   0;
%       50,  75,  100, 125, 150, 175, 200, 225];
nPoints = length(MS);

% ��������
Noise = 0.5;

Xs = [];

for i = 1:nPoints
    % ����BS��MS��ʵ�ʾ���
    for k = 1: BSN
        R0(k) = sqrt((BS(1,k) - MS(1,i))^2 + (BS(2,k) - MS(2, i))^2); 
    end
    % ���������
    for j = 1:100
        % R=R_{i,1},�Ǽ�����������BSi��BS1��MS�ľ�����ʵ��ʹ����Ӧ���� TDOA * c���
        for k = 1: BSN-1
            R(k) = R0(k+1) - R0(1) + Noise * randn(1); 
        end
        X = myChan2(BSN, BS, R);
        Xs = [Xs, X];        
    end
end

plot(Xs(1,:), Xs(2,:), '.');
plot(MS(1,:), MS(2,:), '^', 'markersize', 4, 'Markerfacecolor','y', 'markeredgecolor','k');
legend('Base Station', 'calculated location', 'real location');

[XsRow, XsCol] = size(Xs)
times = XsCol / nPoints;
RMSE = zeros(1, nPoints);
for ii = 1: XsCol
    jj = fix((ii - 1) / times) + 1;
    RMSE(1, jj) = RMSE(1, jj) + (Xs(1, ii) - MS(1, jj)) ^ 2 + (Xs(2, ii) - MS(2, jj)) ^ 2;
end
RMSE = sqrt(RMSE ./ times)

% ��y��������һϵ�е�Ķ�λ���
figure;
plot(MS(2, :), RMSE, '-o');
xlabel('y coordinate');
ylabel('location error(RMSE)');
grid on;
title('y�������϶�λ��������ı仯');


    


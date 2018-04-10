%   �� errorOfMyChan3 ������ͬ��ֻ�Ǳ�ǩ�ڸ���λ��

% ��վ��Ŀ
BSN = 4;

% ������վ��λ��
BS = [0,      0,     10,     10;
      0,     10,     10,      0;
      0,      0,      0,      0]; 
BS = BS(:,1:BSN);

% ������վ��λ��
plot3(BS(1,:), BS(2,:), BS(3,:), 'rs', 'markersize',7, 'Markerfacecolor','r');
axis equal;
grid on;
hold on;

% MS��һϵ��ʵ��λ��
MS = [1,   1,   1,   1,   1,   1,   1,   1,   1,   1;
      1,   1,   1,   1,   1,   1,   1,   1,   1,   1;
      1,   1.5, 2,   2.5, 3,   3.5, 4,   4.5, 5,   5.5];
MS(3, :) = -MS(3, :);
MS = MS(:, 4:10);
nPoints = length(MS);

% ��������
Noise = 0.01;
% ÿ�����Ե�Ĳ��Դ���
times = 10000;

Xs = [];

for i = 1:nPoints
    % ����BS��MS��ʵ�ʾ���
    for k = 1: BSN
        R0(k) = sqrt((BS(1,k) - MS(1,i))^2 + (BS(2,k) - MS(2, i))^2 + (BS(3,k) - MS(3, i))^2); 
    end
    % ���������
    for j = 1:times
        % R=R_{i,1},�Ǽ�����������BSi��BS1��MS�ľ�����ʵ��ʹ����Ӧ���� TDOA * c���
        for k = 1: BSN-1
            R(k) = R0(k+1) - R0(1) + Noise * randn(1); 
        end
        X = myChan3(BSN, BS, R);
        Xs = [Xs, X];        
    end
end

plot3(Xs(1,:), Xs(2,:), Xs(3,:), '.');
plot3(MS(1,:), MS(2,:), MS(3,:), '^', 'markersize', 4, 'Markerfacecolor','y', 'markeredgecolor','k');
legend('Base Station', 'calculated location', 'real location');

[XsRow, XsCol] = size(Xs);
RMSE = zeros(1, nPoints);
for ii = 1: XsCol
    jj = fix((ii - 1) / times) + 1;
%     RMSE(1, jj) = RMSE(1, jj) + (Xs(1, ii) - MS(1, jj)) ^ 2 + (Xs(2, ii) - MS(2, jj)) ^ 2 + (Xs(3, ii) - MS(3, jj)) ^ 2;
    % ������ƽ�����
    RMSE(1, jj) = RMSE(1, jj) + (Xs(1, ii) - MS(1, jj)) ^ 2 + (Xs(2, ii) - MS(2, jj)) ^ 2 ;
end
RMSE = sqrt(RMSE ./ times);

% ��y��������һϵ�е�Ķ�λ���
figure;
plot(MS(3, :), RMSE, '-o');
xlabel('MS height(m)');
ylabel('location error(RMSE) (m)');
grid on;
title('��λ�����߶ȵı仯');


    



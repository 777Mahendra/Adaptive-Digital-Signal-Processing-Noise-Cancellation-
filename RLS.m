function y = RLS(external_noise, noisy_speech, clean_speech, Fs)
    % RLS parameters
    lambda = 1;                 % Exponential Weighting Factor
    delta = 1e-4;               % Value used to initialize P(0)
    p = 13;                     % Filter length
    N = length(external_noise); % Number of samples

    % Initialization
    w = zeros(p, 1);         % Filter coefficients
    P = eye(p)/delta;        % Inverse autocorrelation matrix
    v_hat = zeros(N, 1);     % Estimated noise
    y = zeros(N, 1);         % Output clean speech
    a = zeros(N, 1);         % Error signal

    % Adaptive filtering loop
    for n = 1:N
        % Form input buffer
        buffer = zeros(p, 1);
        for k = 1:p
            idx = n - k + 1;
            if idx > 0
                buffer(k) = external_noise(idx);
            end
        end

        % Compute filtered information vector
        z = P * buffer;

        % Compute gain vector
        g = z / (lambda + buffer' * z);

        % Compute error
        a(n) = noisy_speech(n) - w' * buffer;

        % Update filter coefficients
        w = w + g * a(n);

        % Update inverse correlation matrix
        P = (P - g * z') / lambda;

        % Estimate noise and clean signal
        v_hat(n) = w' * buffer;
        y(n) = noisy_speech(n) - v_hat(n);
    end

    % SNR calculation
    noise_before = noisy_speech - clean_speech;
    noise_after = y - clean_speech;

    snr_before = 10 * log10(sum(clean_speech.^2) / sum(noise_before.^2));
    snr_after = 10 * log10(sum(clean_speech.^2) / sum(noise_after.^2));
    snr_gain = snr_after - snr_before;

    % Print stats
    fprintf('SNR after(RLS): %.2f dB\n', snr_after);
    fprintf('SNR gain(RLS): %.2f dB\n', snr_gain);


    % Plotting
    t = (0:N-1) / Fs;
    figure;
    subplot(3,1,1); plot(t, noisy_speech); title('Noisy Speech s(n)+v(n)'); xlabel('Time (s)');
    subplot(3,1,2); plot(t, y); title('RLS Output (Estimated Clean Speech s(n))'); xlabel('Time (s)');
    subplot(3,1,3); plot(t, clean_speech); title('Ground Truth Clean Speech s(n)'); xlabel('Time (s)');
end
 

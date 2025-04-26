function y = RLS_partial(noisy_speech, external_noise, retain_freqs, Fs, clean_speech)
    % RLS parameters
    lambda = 1;                 % Exponential Weighting Factor
    delta = 1e4;                % Value used to initialize P(0)
    p = 13;                     % Filter length
    N = length(external_noise); % Number of samples
    r = 0.9995;                 % Pole radius for notch filters

    % Initialization
    w = zeros(p, 1);              % Filter coefficients
    P = delta * eye(p);           % Inverse correlation matrix
    v_hat = zeros(N, 1);          % Estimated noise
    v_hat_filtered = zeros(N, 1); % Filtered Estimated noise
    y = zeros(N, 1);              % Output clean speech
    a = zeros(N, 1);              % Error signal

    % Notch filter coefficients
    b_n = zeros(length(retain_freqs), 3);
    a_n = zeros(length(retain_freqs), 3);
    for i = 1:length(retain_freqs)
        w0 = 2 * pi * retain_freqs(i) / Fs; % Notch Frequencies
        b_n(i,:) = [1, -2*cos(w0), 1];
        a_n(i,:) = [1, -2*r*cos(w0), r^2];
    end

    % Buffers for each notch filter stage
    x_stage = zeros(length(retain_freqs), 2);
    y_stage = zeros(length(retain_freqs), 2);

    % Adaptive filtering loop
    for n = 1:N
        % Form input buffer
        buffer = zeros(p, 1);
        for k = 1:p
            if n - k + 1 > 0
                buffer(k) = external_noise(n - k + 1);
            end
        end

        % Estimate full-band noise
        v_hat(n) = w' * buffer;
        v_temp = v_hat(n);

        % Apply notch filters to remove tonal components from v_hat
        for i = 1:length(retain_freqs)
            x_n = v_temp;
            y_n = b_n(i,1)*x_n ...
                + b_n(i,2)*x_stage(i,1) ...
                + b_n(i,3)*x_stage(i,2) ...
                - a_n(i,2)*y_stage(i,1) ...
                - a_n(i,3)*y_stage(i,2);

            x_stage(i,2) = x_stage(i,1);
            x_stage(i,1) = x_n;
            y_stage(i,2) = y_stage(i,1);
            y_stage(i,1) = y_n;

            v_temp = y_n;
        end
        
        % Filtered estimated noise
        v_hat_filtered(n) = v_temp;

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
        y(n) = noisy_speech(n) - v_hat_filtered(n);
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
    subplot(3,1,2); plot(t, y); title('RLS Partial Output (Estimated Partial Clean Speech s(n))'); xlabel('Time (s)');
    subplot(3,1,3); plot(t, clean_speech); title('Ground Truth Clean Speech s(n)'); xlabel('Time (s)');
end

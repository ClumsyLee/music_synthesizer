# 音乐合成综合实验

## 1. 简单的合成音乐

### 1.1 用乐音信号拼出《东方红》第一小节

本题较为简单，可以直接将几个正弦信号拼接在一起实现。

然而，这种实现方法中各个乐音是完全独立的，无法适应 1.2 中用包络修正的需求（即交叠部分无法实现）。

所以，我们采用如下的结构。`*_tone` 函数在某一时刻产生一特定频率的乐音，`make_music` 函数使用传入的乐音生成函数生成《东方红》，`play_music` 函数调用 `make_music` 生成并播放音乐。各个函数代码如下：

```matlab
%% trivial_tone: Generate a tone of a certain frequency
function signal = trivial_tone(t, t_start, duration, f)
    interval = (t >= t_start & t < t_start + duration);

    signal = zeros(size(t));
    signal(interval) = sin(2 * pi * f * t(interval));
```

```matlab
%% make_music: Use certain tone generator to make music.
function [t, music] = make_music(generator, f_sample)
    beat = 0.5;
    t_total = 5;
    f = [349.23, 392, 440, 466.16, 523.25, 587.33, 659.25, 698.46];

    t = linspace(0, t_total - t_total / f_sample, t_total * f_sample);

    tones = [f(5), f(5), f(6), f(2), f(1), f(1), f(6) / 2, f(2)];
    beats = [1, 0.5, 0.5, 2, 1, 0.5, 0.5, 2];

    t_now = 0;
    music = zeros(size(t));
    for tone_num = 1:length(tones)
        duration = beats(tone_num) * beat;
        % Add this tone to the music using generator.
        music = music + generator(t, t_now, duration, tones(tone_num));
        t_now = t_now + duration;
    end

    music = music / max(music);  % Make sure signal <= 1.
```

```matlab
%% play_music: Play music using a certain generator.
function play_music(generator)
    f_sample = 8e3;
    [t, music] = make_music(generator, f_sample);
    sound(music, f_sample);
```

然后使用 `play_music(@trivial_tone)` 来播放音乐，确实可以听到”啪“的杂声。


### 1.2 用包络修正乐音

在这里，我们使用教材中 `图 6.5` 所示的包络描述音量的变化，如下图所示：

![乐音包络](tone_shape.png)

其中参数包括：
* 各段所占时间比例
* 峰值音量
* 持续音量
* 指数衰减系数

代码如下：

```matlab
%% tone_shape: Volumn at a certain time point.
function amp = tone_shape(t, duration)
    % Parameters.
    impulse_ratio = 0.15;
    decay_ratio = 0.15;
    stay_ratio = 0.5;
    peak_amp = 1;
    stay_amp = 0.8;
    fade_coefficient = 7;

    impulse_end = impulse_ratio * duration;
    decay_end = impulse_end + decay_ratio * duration;
    stay_end = decay_end + stay_ratio * duration;

    % Stages.
    impulse = (t >= 0 & t < impulse_end);
    decay = (t >= impulse_end & t < decay_end);
    stay = (t >= decay_end & t < stay_end);
    fade = (t >= stay_end);

    amp = zeros(size(t));
    amp(t < 0) = 0;
    amp(impulse) = linspace(0, peak_amp, sum(impulse));
    amp(decay) = linspace(peak_amp, stay_amp, sum(decay));
    amp(stay) = stay_amp;
    amp(fade) = stay_amp * exp(fade_coefficient * ...
                               (stay_end - t(fade)) / duration);
```

乐音生成函数：

```matlab
%% refined_tone: Generate a tone of a certain frequency with refined shape
function signal = refined_tone(t, t_start, duration, f)
    interval = (t >= t_start);

    signal = zeros(size(t));
    signal = tone_shape(t - t_start, duration) .* sin(2 * pi * f * t);
```

修正后音乐的波形：

![修正后波形](refined_music.png)

### 1.3 升高 & 降低音阶

对于简单的音调变换，可以直接更改输入给 `sound` 的 `FS` 参数，即改变播放时的采样频率。

```matlab
%% trivial_change_octave.m
f_sample = 8e3;
[t, music] = make_music(@refined_tone, f_sample);
sound(music, 2 * f_sample);  % One octave higher.
pause(2.5);
sound(music, 0.5 * f_sample);  % One octave lower.
```

要升高半个音阶，则应该先使用 `rat` 函数找到半个音阶（2^(1/12)）的有理近似，再使用 `resample` 函数进行重采样。代码如下：

```matlab
%% resample_higher_octave.m
f_sample = 8e3;
[Q, P] = rat(2^(1/12), 0.0000001);  % Find the rational approximation.
[t, music] = make_music(@refined_tone, f_sample);
sound(resample(music, P, Q), f_sample);
```

其中 [Q, P] 在实验中得到的实际值是 [3118, 2943]。

需要注意的是，得到的三段音乐都有变速。

### 1.4 增加谐波分量

使用教材中的谐波分量幅度，代码如下

```matlab
%% harmonic_tone: generate a harmonic refined tone of a certain frequency
function signal = harmonic_tone(t, t_start, duration, f)
    interval = (t >= t_start);

    shape = [1, 0.2, 0.3] * sin(2 * pi * f * [1:3]' * t);
    signal = tone_shape(t - t_start, duration) .* shape;
```

其中计算合成信号时使用的是矩阵运算。

合成出的音乐确实要有“厚度”一些，听起来也确实有些像风琴。

### 1.5 自选其他音乐合成

（暂略）

## 2. 用傅里叶级数分析音乐

### 2.1 播放 `fmt.wav`

听起来确实要比刚刚的合成音乐真实不少 = =…

需要注意的是，在 Matlab R2014b 上调用 `wavread` 时得到了一个警告：

    Warning: WAVREAD will be removed in a future release. Use AUDIOREAD
    instead.

所以改为使用 `audioread` 播放音乐：

```matlab
sound(audioread('../../resource/fmt.wav'))
```

### 2.2 预处理 `realwave` => `wave2proc`

从 `realwave` 的时域波形中可以看出，其大约经历了 10 个完整的周期。故为了去除非线性谐波和噪声，我们可以取 10 个周期的均值。

然而注意到 `realwave` 包含 243 个采样点，不是 10 的倍数，故先对其进行 10 倍频，取得周期均值之后将波形重复十次，再进行十分频。

代码如下：

```matlab
%% preprocess: Remove noises from realwave
function wave2proc = preprocess(realwave, cycle)
    cycle_wave = mean(reshape(resample(realwave, cycle, 1), ...
                              [length(realwave), cycle])')';
    wave2proc = resample(repmat(cycle_wave, [cycle, 1]), ...
                         1, cycle);
```

如图所示，处理得到的信号与 `wave2proc` 相差无几：
![wave2proc compare](gen_wave2proc.png)

### 2.3 分析基频 & 谐波

### 2.4 自动分析乐曲的音调和节拍

## 3. 基于傅里叶级数的合成音乐

### 3.1 使用 2.3 的傅里叶级数完成 1.4

### 3.2 演奏一首东方红

### 3.3 用图形界面封装程序

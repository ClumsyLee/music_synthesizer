# 音乐合成综合实验

## 1. 简单的合成音乐

### 1.1 用乐音信号拼出《东方红》第一小节

本题较为简单，可以直接将几个正弦信号拼接在一起实现。

然而，这种实现方法中各个乐音是完全独立的，无法适应 1.2 中用包络修正的需求（即交叠部分无法实现）。

所以，我们采用如下的结构。`*_tone` 函数在某一时刻产生一特定频率的乐音，`make_music` 函数使用传入的乐音生成函数生成《东方红》，`play_music` 函数调用 `make_music` 生成并播放音乐。各个函数代码如下：

```matlab
%% trivial_tone: generate a tone of a certain frequency
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

```matlab

```
```matlab

```
```matlab

```

### 1.3 升高 & 降低音阶

```matlab
[Q, P] = rat(2^(1/12), 0.0000001)
```

## 用傅里叶级数分析音乐

## 基于傅里叶级数的合成音乐

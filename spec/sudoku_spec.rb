require_relative 'spec_helper'
require 'sudoku'

describe Sudoku do
  it 'solves easy grids' do
    expect(
      described_class.solve(%w[
        75893xxx1
        xx1xx5xx4
        xx621x3xx
        x2x6895xx
        x1xx5x6xx
        x9xx218xx
        16xxx8x92
        xxxx7xx3x
        4xxx96x5x
      ]).grid
    ).to eq(%w[
        758934261
        231865974
        946217385
        324689517
        817453629
        695721843
        163548792
        589172436
        472396158
      ])
  end

  it 'solves more difficult grids' do
    expect(
      described_class.solve(%w[
        x79xx1xx3
        xx8x7xxx1
        xx2x34xx5
        xxxxx697x
        x9xxx53xx
        4x1xxxxxx
        x2x1x7xxx
        x1x64853x
        85x2xxx6x
      ]).grid
    ).to eq(%w[
        579861423
        348572691
        162934785
        285316974
        796425318
        431789256
        623157849
        917648532
        854293167
      ])
    end

  it 'solves difficult grid' do
    expect(
      described_class.solve(%w[
        x19xxx2xx
        xxx65xxxx
        xxxxx7135
        x3x47xxxx
        x41xxxxxx
        xxxxxx9x7
        1xxxx8xxx
        4x2xx3xxx
        xxxxxx589
      ]).grid
    ).to eq(%w[
        519834276
        327651498
        864927135
        936475812
        741289653
        258316947
        195768324
        482593761
        673142589
      ])
  end

  it 'solves expert grid 1' do
    expect(
      described_class.solve(%w[
        xxxx83x9x
        6x7xxx3xx
        x1xxxxxxx
        x7x1xxx85
        xxx59xxxx
        xx87xxxxx
        x4xx71xxx
        xx6xxxx5x
        8xxxxxxx3
      ]).grid
    ).to eq(%w[
        254683197
        687915342
        913427568
        479132685
        162598734
        538764219
        345871926
        726349851
        891256473
      ])
  end

  it 'solves expert grid 2' do
    expect(
      described_class.solve(%w[
        xx6x1xxxx
        x2xxx9xxx
        57xxxxxxx
        xx126xx48
        xxxxx3x7x
        xxxxxxxxx
        6xxx41x8x
        xxx3xxxx2
        x34x9xxx6
      ]).grid
    ).to eq(%w[
        946715823
        128639754
        573428169
        351267948
        469183275
        287954631
        692541387
        815376492
        734892516
      ])
  end

  it 'solves expert grid 3' do
    expect(
      described_class.solve(%w[
        xxxx3xxxx
        xx1x7694x
        x8x9xxxxx
        x4xxx1xxx
        x28x9xxxx
        xxxxxx16x
        7xx8xxxxx
        xxxxxx4x2
        x9xx1x3xx
      ]).grid
    ).to eq(%w[
        469138275
        351276948
        287945631
        946751823
        128693754
        573482169
        734829516
        815367492
        692514387
      ])
  end
end
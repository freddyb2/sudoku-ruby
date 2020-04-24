require_relative 'spec_helper'
require 'sudoku'

describe Sudoku do
  it 'solves easy case' do
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
      ])
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

  it 'solves middle case' do
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
      ])
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

  it 'solves difficult case' do
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
      ])
    ).to eq(%w[
        to_do
      ])
  end
end
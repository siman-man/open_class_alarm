RSpec.describe OpenClassAlarm do
  describe 'alarm test' do
    after { OpenClassAlarm.disable }

    context 'non block' do
      before { OpenClassAlarm.enable }

      it 'simple alart case' do
        expect { class Hash; end }.to output(/found open class `Hash'/).to_stderr
      end

      it 'simple non alart' do
        OpenClassAlarm.disable
        expect { class Hash; end }.not_to output(/found open class `Hash'/).to_stderr
      end

      it 'create new class' do
        expect { class NewClass; end }.not_to output(/found open class `NewClass'/).to_stderr
        expect { class NewClass; end }.to output(/found open class `NewClass'/).to_stderr
        OpenClassAlarm.disable
        expect { class NewClass; end }.not_to output(/found open class `NewClass'/).to_stderr
      end

      it 'require library' do
        expect { require 'fixtures/simple_class' }.not_to output(/found open class/).to_stderr
        expect { class SimpleClass; end }.to output(/found open class/).to_stderr
      end
    end

    context 'with block' do
      it 'simple alert' do
        expect {
          OpenClassAlarm.enable do
            class String; end
          end
        }.to output(/found open class `String'/).to_stderr
      end

      it 'no output out of block range' do
        expect {
          OpenClassAlarm.enable do
          end
          class Regexp; end
        }.not_to output(/found open class `Regexp'/).to_stderr
      end
    end
  end
end

# frozen_string_literal: true

RSpec.describe 'readable features' do
  include_context 'item migration'

  describe 'readable_by' do
    context 'accepts associations as arguments' do
      it 'can accept one argument' do
        expect { Item.instance_eval { readable_by :stores } }
          .to_not raise_exception
      end

      it 'can accept multiple arguments' do
        expect { Item.instance_eval { readable_by :stores, :organization } }
          .to_not raise_exception
      end

      it 'and does not throw an exception' do
        expect { Item.instance_eval { readable_by :stores } }
          .to_not raise_exception
      end
    end

    context 'throws an exception' do
      it 'if no arguments are provided' do
        expect { Item.instance_eval { readable_by } }
          .to raise_exception(ArgumentError)
      end

      it 'if the association is missing' do
        expect { Item.instance_eval { readable_by :aliens } }
          .to raise_exception(Permissions::UnknownAssociation, 'Cannot find association `aliens`')
      end

      it 'if any association is missing' do
        expect { Item.instance_eval { readable_by :stores, :aliens } }
          .to raise_exception(Permissions::UnknownAssociation, 'Cannot find association `aliens`')
      end
    end
  end
end

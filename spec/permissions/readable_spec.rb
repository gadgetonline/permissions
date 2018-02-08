# frozen_string_literal: true

RSpec.describe 'readable features' do
  after(:all) do
    ActiveRecord::Migration.drop_table :people
  end

  before(:all) do
    ActiveRecord::Migration.create_table :people, force: true do |t|
      t.string :name, default: nil, required: false
    end
  end

  describe 'readable_by' do
    context 'accepts associations as arguments' do
      it 'can accept one argument' do
        expect { Person.instance_eval { readable_by :groups } }
          .to_not raise_exception
      end

      it 'can accept multiple arguments' do
        expect { Person.instance_eval { readable_by :groups, :departments } }
          .to_not raise_exception
      end

      it 'and does not throw an exception' do
        expect { Person.instance_eval { readable_by :groups } }
          .to_not raise_exception
      end
    end

    context 'throws an exception' do
      it 'if no arguments are provided' do
        expect { Person.instance_eval { readable_by } }
          .to raise_exception(ArgumentError)
      end

      it 'if the association is missing' do
        expect { Person.instance_eval { readable_by :aliens } }
          .to raise_exception(Permissions::UnknownAssociation, 'Cannot find association `aliens`')
      end

      it 'if any association is missing' do
        expect { Person.instance_eval { readable_by :groups, :aliens } }
          .to raise_exception(Permissions::UnknownAssociation, 'Cannot find association `aliens`')
      end
    end
  end
end

# frozen_string_literal: true

require_relative '../support/classes/place_holder'

module Permissions
  RSpec.describe Permission, type: :model do
    describe 'Associations' do
      it { is_expected.to belong_to(:grantee) }
    end

    describe 'Database' do
      context 'Columns' do
        it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
        it { is_expected.to have_db_column(:expires_at).of_type(:datetime) }
        it { is_expected.to have_db_column(:grantee_id).of_type(:integer) }
        it { is_expected.to have_db_column(:grantee_type).of_type(:string) }
        it { is_expected.to have_db_column(:object_id).of_type(:integer) }
        it { is_expected.to have_db_column(:object_type).of_type(:string) }
        it { is_expected.to have_db_column(:right).of_type(:integer) }
      end
    end

    describe 'Validations' do
      context 'grantee_type' do
        subject(:permission) { build :permission, object_type: 'PlaceHolder' }

        it 'can be a known class' do
          allow(PlaceHolder).to receive(:find_by) { :found }
          permission.grantee_type = 'PlaceHolder'
          expect(permission).to be_valid
        end

        it 'cannot be a missing record of a known class' do
          allow(PlaceHolder).to receive(:find_by) { nil }
          permission.grantee_type = 'PlaceHolder'
          expect(permission).to_not be_valid
        end

        it 'cannot be nil' do
          expect(build(:permission, grantee_type: nil)).to_not be_valid
        end

        it 'cannot be an unknown class' do
          expect(build(:permission, grantee_type: 'Unknown')).to_not be_valid
        end
      end

      context 'object_type' do
        subject(:permission) { build :permission, grantee_type: 'PlaceHolder' }

        it 'can be a known class' do
          allow(PlaceHolder).to receive(:find_by) { :found }
          permission.object_type = 'PlaceHolder'
          expect(permission).to be_valid
        end

        it 'cannot be a missing record of a known class' do
          allow(PlaceHolder).to receive(:find_by) { nil }
          permission.object_type = 'PlaceHolder'
          expect(permission).to_not be_valid
        end

        it 'cannot be nil' do
          permission.object_type = nil
          expect(permission).to_not be_valid
        end

        it 'cannot be an unknown class' do
          permission.object_type = 'Unknown'
          expect(permission).to_not be_valid
        end
      end

      context 'right' do
        subject(:permission) do
          build :permission, grantee_type: 'PlaceHolder', object_type: 'PlaceHolder'
        end

        it 'can be set to a valid, pre-defined right' do
          allow(PlaceHolder).to receive(:find_by) { :found }
          permission.right = 'create'
          expect(permission).to be_valid
        end

        it 'throws exception on an unknown right' do
          expect { permission.right = 'xxx' }
            .to(raise_exception(ArgumentError))
        end
      end
    end
  end
end

# -*- encoding: utf-8 -*-

class Kuroneko
  # 状態情報
  Status = Struct.new(:number, :latest, :status, :date, :time, :branch, :branch_code)

  class Status
    # @!attribute number
    #   @return [String] 伝票番号
    #   @example
    #     "123456789012"
    #   @note 数字以外 (ハイフン等) は含まない

    # @!attribute latest
    #   @return [Boolean] 最新の状態であるか

    # @!attribute status
    #   @return [String] 状態名
    #   @example
    #     "配達完了"

    # @!attribute date
    #   @return [String] 状態発生日
    #   @example
    #     "12/31"

    # @!attribute time
    #   @return [String] 状態発生時刻
    #   @example
    #     "12:59"

    # @!attribute branch
    #   @return [String] 担当店
    #   @example
    #     "北東京ベース店"

    # @!attribute branch_code
    #   @return [String] 担当店コード
    #   @example
    #     "030990"

    # @return [Boolean] 最新の状態であるか
    alias latest? latest

  end
end

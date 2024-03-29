require File.dirname(__FILE__) + '/test_helper'

class TimeTest < Test::Unit::TestCase
  
  #to_s
  def test_time_to_s_with_traditional_format
    assert_equal "Mon Sep 24 16:03:05 UTC 2007", "Mon Sep 24 16:03:05 UTC 2007".to_time.to_s
  end
  
  #to_s_br
  def test_time_to_s_br
    assert_equal "24/09/2007 16:03", "Mon Sep 24 16:03:05 UTC 2007".to_time.to_s_br
  end
  
  def test_month_names
    assert_equal [nil,
      "Janeiro",
      "Fevereiro",
      "Marco",
      "Abril",
      "Maio",
      "Junho",
      "Julho",
      "Agosto",
      "Setembro",
      "Outubro",
      "Novembro",
      "Dezembro"],
      Time::MONTHNAMES
  end
	
  def test_days_names
    assert_equal ["Domingo",
      "Segunda-Feira",
      "Terca-Feira",
      "Quarta-Feira",
      "Quinta-Feira",
      "Sexta-Feira",
      "Sabado"],
      Time::DAYNAMES
  end

  def test_abbr_monthnames
    assert_equal [nil,
      "Jan",
      "Fev",
      "Mar",
      "Abr",
      "Mai",
      "Jun",
      "Jul",
      "Ago",
      "Set",
      "Out",
      "Nov",
      "Dez"],
      Time::ABBR_MONTHNAMES
  end

  def test_abbr_daysnames
    assert_equal ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sab"], Time::ABBR_DAYNAMES
  end

end

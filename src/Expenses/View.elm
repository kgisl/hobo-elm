module Expenses.View exposing(root)

import Html exposing (..)
import Html.App exposing (map)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Date
-- import Platform.Cmd as Cmd

import Types exposing (..)
import Expenses.Types exposing (..)
import Budgets.View as Budgets

import Utils.Expenses exposing (getTotal)
import Utils.Numbers exposing (formatAmount)


root : User -> Model -> Html Msg
root user model =
  let
    filter expense =
      Just expense.budgetId == model.buttons.currentBudgetId || model.buttons.currentBudgetId == Nothing
    expenses = List.filter filter model.expenses
    expensesTotal = getTotal expenses |> formatAmount

  in
    div [ ] [
      viewBudgets user model.expenses model,
      viewExpenseForm model,

      div [ class "clear" ] [
        weekHeader model expensesTotal
      ],

      div [ class "clear" ] [
        viewExpenseList expenses expensesTotal
      ]
    ]


expenseItem : Expense -> Html Msg
expenseItem expense =
  tr [ ] [
    td [ ] [
      span [ class "date" ] [
        div [ class "date-header" ] [ text (Date.month expense.createdAt |> toString) ],
        div [ class "date-day" ] [ text (Date.day expense.createdAt |> toString) ]
      ]
    ],
    td [ ] [
      a [ href "#" ] [ text expense.budgetName ]
    ],
    td [ ] [ text expense.createdByName ],
    td [ class "text-right" ] [ text (formatAmount expense.amount) ]
  ]


viewExpenseList : List Expense -> String -> Html Msg
viewExpenseList filteredExpenses totalString =
  div [ class "clear col-12 push-2-tablet push-3-desktop push-3-hd col-8-tablet col-6-desktop col-5-hd" ] [
    table [ ] [
      tbody [ ] (List.map expenseItem filteredExpenses),
      tfoot [ ] [
        tr [ ] [
          th [ ] [ text "" ],
          th [ ] [ text "" ],
          th [ ] [ text "Total:" ],
          th [ class "text-right" ] [ text totalString ]
        ]
      ]
    ]
  ]


viewExpenseForm : Model -> Html Msg
viewExpenseForm model =
  div [ class "clear" ] [
    div [ class "field-group" ] [
      div [ class "col-8" ] [
        input [ class "field",
                type' "number",
                id "amount",
                name "amount",
                value model.amount,
                placeholder "Amount",
                autocomplete False,
                onInput AmountInput ] [ ]
      ],
      div [ class "col-4" ] [
        button [ class "button week-button", onClick RequestAdd, disabled (model.buttons.currentBudgetId == Nothing || model.amount == "") ] [ text "Add" ]
      ]
    ]
  ]


viewBudgets : User -> List Expense -> Model -> Html Msg
viewBudgets user expenses model =
  Html.App.map BudgetList (Budgets.root user model.weekNumber expenses model.buttons)


weekHeader : Model -> String -> Html Msg
weekHeader model total =
  let
    weekName = if model.weekNumber == 0 then "This week" else
               if model.weekNumber == -1 then "Last week" else
               (toString -model.weekNumber) ++ " weeks ago"

    rightDisabledClass = if model.weekNumber == 0 then " disabled" else ""
  in
    div [ class "clear" ] [
      div [ class "col-3 col-1-hd" ] [
        button [ class "button week-button", onClick LoadPreviousWeek ] [ text "<<" ]
      ],
      div [ class "col-6 col-10-hd" ] [
        div [ class "week-header" ] [ text (weekName ++ " - " ++ total)]
      ],
      div [ class "col-3 col-1-hd" ] [
        button [ class ("button week-button" ++ rightDisabledClass), onClick LoadNextWeek ] [ text ">>" ]
      ]
    ]


viewExpense : User -> Model -> Html Msg
viewExpense user model =
  div [ ] [
    text "It works!"
  ]
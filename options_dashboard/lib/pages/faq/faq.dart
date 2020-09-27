import 'package:flutter/material.dart';

class FAQ extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQs'),
      ),
      body: ListView.builder(
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return _FAQQuestion(faqs[index]);
        },
        padding: EdgeInsets.all(8),
      ),
      // drawer: DrawerItems(),
    );
  }
}

class _FAQQuestion extends StatelessWidget {
  final Map<String, String> question;

  _FAQQuestion(
    this.question,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question['question'],
            style: TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 3,
          ),
          Text(
            question['answer'],
            style: TextStyle(
              fontSize: 16,
            ),
            maxLines: 20,
          ),
          Divider(
            color: Colors.indigo,
          )
        ],
      ),
    );
  }
}

List<Map<String, String>> faqs = [
  {
    'question': 'What does the Risk tab tell me?',
    'answer':
        'The Stats tab provides risk management information for traders to more easily decide if an order is worth placing and if it is what size of position they should take.',
  },
  {
    'question': 'What is P.O.P.?',
    'answer':
        'P.O.P. stands for probability of profit, given as a percent. P.O.P. reflects the strategy\'s likelihood of expiring at profitable stock price.\n Traders may close their position early to take profits or cut losses, but this is not reflected in probability of profit.',
  },
  {
    'question': 'What is R.O.R.?',
    'answer':
        'R.O.R. stands for risk of ruin, given as a percent. R.O.R. is the likelihood that a trader will loose their complete portfolio if they they were to only make trades with this stategy\'s risk profile and their specified trade size (default is 10% of their portfolio). \n \nTraders who wish to reduce their R.O.R. should consider making smaller trades, as well increasing their Payoff Ratio and P.O.P. \n\nMore information is avaiable at _____',
  },
  {
    'question': 'What statistical models are used to determine these values?',
    'answer':
        'All these metrics are dependent on the future price of the underlying security. In order to estimate this we assume a 0 % return, the average at the money implied volatility is the true volatility of the security, and that the future price of the security follows a log-normal distribution.\n\nThese assumptions are for educationcational prusposes only.',
  },
  {
    'question': '',
    'answer': '',
  },
  {
    'question': '',
    'answer': '',
  },
];

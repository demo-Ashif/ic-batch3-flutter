import 'package:flutter/material.dart';
import 'package:ic_batch3_flutter_classes/domain/models/invoice_response.dart';
import 'package:ic_batch3_flutter_classes/domain/models/payment_method.dart';
import 'package:ic_batch3_flutter_classes/presentation/checkout/pages/payment_webview_page.dart';

class CheckoutDetailPage extends StatelessWidget {
  const CheckoutDetailPage({super.key, required this.invoiceData});

  final InvoiceData invoiceData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Payment Method'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          _PaymentSummary(invoiceData: invoiceData),
          Expanded(
            child: _PaymentMethodsList(
              paymentMethods: invoiceData.paymentMethods,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentSummary extends StatelessWidget {
  const _PaymentSummary({required this.invoiceData});

  final InvoiceData invoiceData;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Summary',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _SummaryRow(label: 'Subtotal', amount: invoiceData.total),
          const SizedBox(height: 8),
          _SummaryRow(label: 'VAT', amount: invoiceData.vat),
          const Divider(height: 24),
          _SummaryRow(
            label: 'Total Payable',
            amount: invoiceData.payable,
            isTotal: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.amount,
    this.isTotal = false,
  });

  final String label;
  final int amount;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style:
              isTotal
                  ? Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
                  : Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          '${amount.toStringAsFixed(0)} Tk',
          style:
              isTotal
                  ? Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  )
                  : Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

class _PaymentMethodsList extends StatelessWidget {
  const _PaymentMethodsList({required this.paymentMethods});

  final List<PaymentMethod> paymentMethods;

  @override
  Widget build(BuildContext context) {
    // Group payment methods by type
    final groupedMethods = <String, List<PaymentMethod>>{};
    for (final method in paymentMethods) {
      groupedMethods.putIfAbsent(method.type, () => []).add(method);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: groupedMethods.length,
      itemBuilder: (context, index) {
        final entry = groupedMethods.entries.elementAt(index);
        final type = entry.key;
        final methods = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                _getTypeDisplayName(type),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            ...methods.map(
              (method) => _PaymentMethodCard(
                method: method,
                onTap: () => _onPaymentMethodTap(context, method),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  String _getTypeDisplayName(String type) {
    switch (type) {
      case 'visa':
        return 'Credit/Debit Cards';
      case 'master':
        return 'Credit/Debit Cards';
      case 'amex':
        return 'Credit/Debit Cards';
      case 'mobilebanking':
        return 'Mobile Banking';
      case 'internetbanking':
        return 'Internet Banking';
      case 'othercards':
        return 'Other Payment Methods';
      default:
        return type.toUpperCase();
    }
  }

  void _onPaymentMethodTap(BuildContext context, PaymentMethod method) {
    if (method.redirectGatewayURL != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => PaymentWebViewPage(
                paymentUrl: method.redirectGatewayURL!,
                paymentMethodName: method.name,
              ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${method.name} is not available at the moment'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({required this.method, required this.onTap});

  final PaymentMethod method;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            method.logo,
            width: 48,
            height: 48,
            fit: BoxFit.contain,
            errorBuilder:
                (_, __, ___) => Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.payment,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
          ),
        ),
        title: Text(
          method.name,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          _getMethodDescription(method.type),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        trailing:
            method.redirectGatewayURL != null
                ? Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                )
                : Icon(Icons.block, color: Theme.of(context).colorScheme.error),
        onTap: method.redirectGatewayURL != null ? onTap : null,
      ),
    );
  }

  String _getMethodDescription(String type) {
    switch (type) {
      case 'visa':
      case 'master':
      case 'amex':
        return 'Credit/Debit Card';
      case 'mobilebanking':
        return 'Mobile Banking';
      case 'internetbanking':
        return 'Internet Banking';
      case 'othercards':
        return 'Digital Wallet';
      default:
        return 'Payment Method';
    }
  }
}

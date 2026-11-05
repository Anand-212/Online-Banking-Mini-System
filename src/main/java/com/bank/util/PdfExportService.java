package com.bank.util;

import com.bank.model.Transaction;
import com.bank.model.User;
import com.lowagie.text.*;
import com.lowagie.text.pdf.*;

import java.awt.Color;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.List;

public class PdfExportService {

    public static void generateTransactionHistoryPdf(User user, List<Transaction> transactions, OutputStream out) throws Exception {
        Document document = new Document(PageSize.A4, 36, 36, 36, 36);
        PdfWriter.getInstance(document, out);
        document.open();

        // Header Styling
        Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18, Color.DARK_GRAY);
        Font subTitleFont = FontFactory.getFont(FontFactory.HELVETICA, 10, Color.GRAY);
        Font sectionFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, new Color(15, 23, 42));
        Font textFont = FontFactory.getFont(FontFactory.HELVETICA, 10, Color.BLACK);

        Paragraph header = new Paragraph("EASYBANK ONLINE BANKING SYSTEM", titleFont);
        header.setAlignment(Element.ALIGN_CENTER);
        document.add(header);

        Paragraph subHeader = new Paragraph("Official Account Statement & Transaction History", subTitleFont);
        subHeader.setAlignment(Element.ALIGN_CENTER);
        subHeader.setSpacingAfter(15);
        document.add(subHeader);

        // Account Metadata Table
        PdfPTable metaTable = new PdfPTable(2);
        metaTable.setWidthPercentage(100);
        metaTable.setSpacingAfter(15);

        metaTable.addCell(createCell("Account Holder: " + user.getFullName(), textFont, false));
        metaTable.addCell(createCell("Account Number: " + user.getAccountNumber(), textFont, false));
        metaTable.addCell(createCell("Email: " + user.getEmail(), textFont, false));
        metaTable.addCell(createCell("Current Balance: Rs. " + user.getBalance(), textFont, false));
        document.add(metaTable);

        // Transaction Data Table
        PdfPTable table = new PdfPTable(6);
        table.setWidthPercentage(100);
        table.setWidths(new float[]{3f, 2.5f, 2f, 2.5f, 2.5f, 2.5f});

        String[] headers = {"Tx ID", "Date", "Type", "Amount", "Sender/Recv", "Status"};
        Font headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, Color.WHITE);
        for (String h : headers) {
            PdfPCell cell = new PdfPCell(new Phrase(h, headerFont));
            cell.setBackgroundColor(new Color(15, 23, 42));
            cell.setPadding(6);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            table.addCell(cell);
        }

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        for (Transaction tx : transactions) {
            table.addCell(createCell(tx.getTransactionId(), textFont, true));
            table.addCell(createCell(sdf.format(tx.getTransactionDate()), textFont, true));
            table.addCell(createCell(tx.getTransactionType(), textFont, true));
            table.addCell(createCell("Rs. " + tx.getAmount(), textFont, true));
            
            String party = tx.getSenderAccount() != null ? tx.getSenderAccount() : tx.getReceiverAccount();
            table.addCell(createCell(party != null ? party : "N/A", textFont, true));
            table.addCell(createCell(tx.getStatus(), textFont, true));
        }

        document.add(table);
        
        Paragraph footer = new Paragraph("\nGenerated automatically by EasyBank Online Banking Portal.", subTitleFont);
        footer.setAlignment(Element.ALIGN_CENTER);
        document.add(footer);

        document.close();
    }

    private static PdfPCell createCell(String text, Font font, boolean center) {
        PdfPCell cell = new PdfPCell(new Phrase(text, font));
        cell.setPadding(5);
        if (center) cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        return cell;
    }
}
